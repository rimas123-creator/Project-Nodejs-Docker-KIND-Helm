# KIND-Helm Node.js Deployment Example

This project demonstrates deploying a Node.js application to a local Kubernetes cluster using [KIND](https://kind.sigs.k8s.io/) and [Helm](https://helm.sh/).

## Prerequisites

- Docker
- KIND
- kubectl
- Helm
- Node.js

## Steps

### 1. Build and Push Docker Image

```sh
docker build -t helm-node-app .
docker tag helm-node-app:latest caderrimas/helm-node-app:v1
docker login -u <your-dockerhub-username> -p <your-dockerhub-password>
docker push caderrimas/helm-node-app:v1
```

### 2. Create KIND Cluster

```sh
kind create cluster --name=helm-node-cluster
kubectl get nodes
```

### 3. Create Kubernetes Secret for Docker Registry

```sh
kubectl create secret docker-registry helm-node-image-secret \
  --docker-username=<your-dockerhub-username> \
  --docker-password=<your-dockerhub-password> \
  --docker-server=https://index.docker.io/v1/ \
  --docker-email=<your-email> \
  --namespace=default
```

### 4. Deploy with Helm

```sh
helm create helm-node-app
helm install helm-node-app-release ./helm-node-app
```

### 5. Apply Kubernetes Manifests (if not using Helm)

```sh
kubectl apply -f k8s/manifests/deployment.yaml
kubectl apply -f k8s/manifests/service.yaml
kubectl apply -f k8s/manifests/hpa.yaml
```

### 6. Check Resources

```sh
kubectl get deploy
kubectl get pods
kubectl get svc
kubectl get hpa
```

### 7. View Pod Logs

```sh
kubectl logs <pod-name>
```

## Helm Chart Structure

- `helm-node-app/` - Helm chart directory
  - `templates/` - Kubernetes manifests with Helm templating
  - `values.yaml` - Default values for the chart

## Notes

- The deployment uses an `imagePullSecret` for private Docker images.
- Horizontal Pod Autoscaler (HPA) is included for autoscaling.
- Example manifests are in `k8s/manifests/`.

## Useful Commands

- List Helm releases:  
  `helm list`
- Uninstall release:  
  `helm uninstall <release-name>`
- Upgrade release:  
  `helm upgrade <release-name> ./helm-node-app`
- Package chart:  
  `helm package ./helm-node-app`
- Add Helm repo:  
  `helm repo add <repo-name> <repo-url>`
- Search Helm repo:  
  `helm search repo <chart-name>`