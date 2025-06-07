#!/bin/bash

# Fix ArgoCD notifications cache invalidation issue
echo "Fixing ArgoCD notifications cache invalidation issue..."

# Create or update the notifications ConfigMap with proper configuration
kubectl apply -n argocd -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
  namespace: argocd
data:
  service.webhook.my-webhook: |
    url: https://example.com/webhook
  trigger.on-sync-status-unknown: |
    - when: app.status.sync.status == 'Unknown'
      send: [app-sync-status]
  template.app-sync-status: |
    message: Application {{.app.metadata.name}} sync status is {{.app.status.sync.status}}.
  defaultTriggers: |
    - on-sync-status-unknown
EOF

# Create or update the notifications Secret with proper token
kubectl apply -n argocd -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: argocd-notifications-secret
  namespace: argocd
stringData:
  webhook.my-webhook.token: dummy-token
type: Opaque
EOF

# Restart the notifications controller to apply changes
kubectl rollout restart deployment argocd-notifications-controller -n argocd

echo "Waiting for ArgoCD notifications controller to restart..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-notifications-controller -n argocd --timeout=60s

echo "Fix applied. The cache invalidation messages should stop appearing in the logs."