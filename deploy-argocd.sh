CLIENT_SECRET=$(terraform output -raw -state=$TF_STATE client-secret)
helm upgrade --install --wait --timeout 35m --atomic --namespace argocd --create-namespace  \
  --repo https://argoproj.github.io/argo-helm argocd argo-cd --values - <<EOF
redis:
  enabled: true
redis-ha:
  enabled: false
global:
  domain: argocd.kind.cluster
configs:
  params:
    server.insecure: 'true'
  cm:
    url: http://argocd.kind.cluster
    application.instanceLabelKey: argocd.argoproj.io/instance
    admin.enabled: 'false'
    oidc.config: |
      name: Keycloak
      issuer: http://keycloak.kind.cluster/auth/realms/master
      clientID: argocd
      clientSecret: $CLIENT_SECRET
      requestedScopes: ['openid', 'profile', 'email', 'groups']  
  rbac:
    policy.default: role:readonly
    policy.csv: |
      g, argocd-admin, role:admin
server:
  config:
    resource.exclusions: |
      - apiGroups:
          - cilium.io
        kinds:
          - CiliumIdentity
        clusters:
          - '*'
  ingress:
    annotations:
      kubernetes.io/ingress.class: nginx
    enabled: true
    ingressClassName: nginx
    hostname: argocd.kind.cluster
    tls: false
EOF