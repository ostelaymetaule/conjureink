# build docker image
docker build -t conjureink .

# set kube config
export KUBECONFIG=~/.kube/config

# create namespace
kubectl apply -f conjureink-test-namespace.yaml

# set namespace
sudo kubectl config set-context --current --namespace=conjureink-test-namespace
# validate the namespace was switched
kubectl config view | grep namespace:


# for cicd using github actions we need to create Personal Access Token and authorize the kubernetes 
kubectl delete secret docker-registry ghcr-login-secret --ignore-not-found --namespace=conjureink-test-namespace
kubectl create secret docker-registry ghcr-login-secret --docker-server=https://ghcr.io --docker-username=${{ github.actor }} --docker-password=${{ secrets.GITHUB_TOKEN }} --docker-email=${{ secrets.MY_EMAIL }} --namespace=conjureink-test-namespace


# add reference to the secret from the configmap to the deployment.yaml:
      imagePullSecrets:
      - name: ghcr-login-secret



# export local image to kube 
sudo docker save conjureink:latest | sudo k3s ctr images import -

# apply configmap
kubectl apply -f conjureink-test-configmap.yaml

# apply deployment
kubectl apply -f conjureink-test-deployment.yaml

# export service
kubectl expose deployment conjureink-deployment  --port 80 --target-port 80

# configure ingress
kubectl apply -f conjureink-test-ingress.yaml

# dont forget to get the client certificate for ravendb:
# With security clearance set to Operator, the user of this certificate will have access to all database


# when the openlens or kubectl cant login to the cluster, probably need to rotate the certificates
kubectl --kubeconfig %path%/kubeconfig-contabo.yaml get pods
error: You must be logged in to the server (Unauthorized)
# to check on that, decode from base64 client certificate from the kubeconfig and check the expiration date
# then update the certs
# Stop K3s
systemctl stop k3s

# Rotate certificates
k3s certificate rotate

# Start K3s
systemctl start k3s


