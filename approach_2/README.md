
### Deploy ArgoCD and Image Updater with Helm and Terraform: 
- argo.tf
- image-updater.tf
- provider.tf

**Externalize their configuration**:
- argo.yaml
- image-updater.yaml

**Run to deploy**:
- terraform init
- terraform apply
- kubectl get pods -n argocd

**Connect to GUI**:
k get svc -n argocd
kubectl port-forward svc/argocd-server -n argocd 8080:80
http://localhost:8080/
k get secrets -n argocd
k get secret argocd-initial-admin-secret -o yaml -n argocd
password: NnhVZEpWSWtWcTl4SjI5dw==
echo "NnhVZEpWSWtWcTl4SjI5dw==" | base64 -d #exclude % at the end
6xUdJVIkVq9xJ29w

### To do this generate an SSH:
ssh-keygen -t ed25519 -C "nmendybaev@gmail.com" -f ~/.ssh/r_w_argo
Generated public key is here:
cat ~/.ssh/r_w_argo.pub 
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMbO8mxhl5poDPpnMfTE+szxpaG1e+A1+NCQBRAXndH nmendybaev@gmail.com


### Add public SSH key to a private repo 'nginx-private':
github - private repo - settings - deploy keys - add new - title: private_key, key: ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMbO8mxhl5poDPpnMfTE+szxpaG1e+A1+NCQBRAXndH nmendybaev@gmail.com, allow write access!

### Add private SSH key to a 'git-private-secret.yaml' and point it to a private GitHub repo: 'git@github.com:nmendybayev/nginx-private-argo.git'
cat ~/.ssh/r_w_argo    
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACCjGzvJsYZeaaAz6ZzH0xPrM8aWhtXvgNfjQkAUQF53RwAAAJh9/TDvff0w
7wAAAAtzc2gtZWQyNTUxOQAAACCjGzvJsYZeaaAz6ZzH0xPrM8aWhtXvgNfjQkAUQF53Rw
AAAEDpjQPxNjH916V0Y0yI3syY2tUrK46e0QhNKCbbAHsITaMbO8mxhl5poDPpnMfTE+sz
xpaG1e+A1+NCQBRAXndHAAAAFG5tZW5keWJhZXZAZ21haWwuY29tAQ==
-----END OPENSSH PRIVATE KEY----



**sealed cerets**
#helm repo add bitnami https://charts.bitnami.com/bitnami
#helm search repo sealed
#kubectl get pods -n kube-system
#kubectl get svc -n kube-system
#brew install kubeseal
#kubeseal --fetch-cert --controller-name sealed-secrets --controller-namespace kube-system
#nginx-private-argo % kubeseal --controller-name sealed-secrets -o yaml --controller-namespace kube-system < dockerconfigjson.yaml > docker-sealed-secret.yaml
#nginx-private-argo % kubeseal --controller-name sealed-secrets -o yaml --controller-namespace kube-system < git-private-secret.yaml > github-sealed-secret.yaml
