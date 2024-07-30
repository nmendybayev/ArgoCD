#!/bin/bash

# exit when any command fails
set -e

# Check if new version is passed as an argument
if [ -z "$1" ]; then
  echo "Error: No version provided."
  echo "Usage: $0 <new_version>"
  exit 1
fi

new_ver=$1
echo "new version: $new_ver"

# Load username and password variables from .env file
if [ -f .env ]; then
  export $(cat .env | xargs)
else
  echo "Error: .env file not found."
  exit 1
fi

# Log in to a private DockerHub repo 
echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin
if [ $? -ne 0 ]; then
  echo "Docker login failed."
  exit 1
fi

# Release of the new docker images (read comment below!)
docker tag nurbolm/argocd:v0.1.0 nurbolm/argocd:$new_ver
if [ $? -ne 0 ]; then
  echo "Docker tag failed."
  exit 1
fi

# Generally, instead of releasing, CI Agent should run 'docker build -t nurbolm/argocd:$new_ver' 
# ... command creating a new Docker image as a result of the CI process.

# Push new version to dockerhub
docker push nurbolm/argocd:$new_ver
if [ $? -ne 0 ]; then
  echo "Docker push failed."
  exit 1
fi

# Create a temporary folder
tmp_dir=$(mktemp -d)
if [ $? -ne 0 ]; then
  echo "Failed to create temporary directory."
  exit 1
fi
echo "Temporary directory created at $tmp_dir"

# Clone a private GitHub repo into a temporary folder
git clone git@github.com:nmendybayev/nginx-private-argo.git $tmp_dir
if [ $? -ne 0 ]; then
  echo "Git clone failed."
  exit 1
fi

# Update image tag
sed -i '' -e "s/nurbolm\/argocd:.*/nurbolm\/argocd:$new_ver/g" $tmp_dir/environments/dev/my-app/deployment.yaml
if [ $? -ne 0 ]; then
  echo "Failed to update image tag in deployment.yaml."
  exit 1
fi

# Commit and push
cd $tmp_dir
git add .
git commit -m "Update image to $new_ver"
git push
if [ $? -ne 0 ]; then
  echo "Git push failed."
  exit 1
fi

# Optionally on build agents - remove folder
rm -rf $tmp_dir
echo "Temporary directory $tmp_dir removed."