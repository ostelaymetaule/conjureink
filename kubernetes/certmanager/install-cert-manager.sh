echo installing helm chart for cert-manager
helm install \
 cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true \
  --set prometheus.enabled=false

  #https://artifacthub.io/packages/helm/cert-manager/cert-manager