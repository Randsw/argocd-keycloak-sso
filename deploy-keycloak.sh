helm upgrade --install --wait --timeout 35m --atomic --namespace keycloak --create-namespace \
  --repo https://codecentric.github.io/helm-charts keycloak keycloak --values - <<EOF
extraEnv: |
  - name: KEYCLOAK_USER
    value: admin
  - name: KEYCLOAK_PASSWORD
    value: admin
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
  ingressClassName: nginx
  rules:
    - host: keycloak.kind.cluster
      paths:
        - path: /
          pathType: Prefix
EOF