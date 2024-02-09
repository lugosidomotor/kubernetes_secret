#!/bin/bash

backup_secret() {
  local namespace="$1"
  local secret_name="$2"
  local date_stamp=$(date +%Y%m%d%H%M%S) # Időbélyeg hozzáadása
  local backup_secret_name="${secret_name}.backup.${date_stamp}" # Egyedi backup neve

  # Új backup secret létrehozása anélkül, hogy törölnénk a régit
  echo "Új backup secret létrehozása: $backup_secret_name"
  kubectl get secret "$secret_name" -n "$namespace" -o yaml |
    sed "s/name: $secret_name/name: $backup_secret_name/" |
    kubectl apply -f - -n "$namespace"
  echo "Új backup secret sikeresen létrehozva: $backup_secret_name."
}

# A függvény használata: backup_secret [namespace] [secret_name]
backup_secret "default" "my-secret"
