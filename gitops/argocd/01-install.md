# Install Argo CD

## Install Argo CD using manifests

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

If: 
kubectl apply --server-side --force-conflicts -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## Access the Argo CD UI (Loadbalancer service) 

```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```
## Access the Argo CD UI (Loadbalancer service) -For Windows

```bash
kubectl patch svc argocd-server -n argocd -p '{\"spec\": {\"type\": \"LoadBalancer\"}}'
```

## Get the Loadbalancer service IP

```bash
kubectl get svc argocd-server -n argocd
```
```bash
Get password:
kubectl get secrets -n argocd

$ kubectl get secrets -n argocd
NAME                          TYPE     DATA   AGE
argocd-initial-admin-secret   Opaque   1      11m
argocd-notifications-secret   Opaque   0      11m
argocd-redis                  Opaque   1      11m
argocd-secret                 Opaque   5      11m

kubectl edit secret argocd-initial-admin-secret -n argocd

echo <password-hash> | base64 --decode
```
