#!/bin/bash

backup_secret() {
  local namespace="$1"
  local secret_name="$2"
  local backup_secret_name="${secret_name}.backup"

  echo "Új backup secret létrehozása: $backup_secret_name"
  kubectl get secret "$secret_name" -n "$namespace" -o yaml |
    sed "s/name: $secret_name/name: $backup_secret_name/" |
    kubectl apply -f - -n "$namespace"
  echo "Új backup secret sikeresen létrehozva: $backup_secret_name."
}

# A függvény használata: backup_secret [namespace] [secret_name]
backup_secret "default" "my-secret"
