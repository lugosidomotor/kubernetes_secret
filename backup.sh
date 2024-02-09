#!/bin/bash

backup_secret() {
  local namespace="$1"
  local secret_name="$2"
  local backup_secret_name="${secret_name}.backup"

  echo "Új backup secret létrehozása: $backup_secret_name"

  # Először megpróbáljuk létrehozni a backup Secret-et
  if ! kubectl get secret "$backup_secret_name" -n "$namespace" &> /dev/null; then
    kubectl get secret "$secret_name" -n "$namespace" -o yaml |
      sed "s/name: $secret_name/name: $backup_secret_name/" |
      kubectl create -f - -n "$namespace"
    echo "Új backup secret sikeresen létrehozva: $backup_secret_name."
  else
    # Ha a Secret már létezik, akkor megpróbáljuk azt frissíteni
    kubectl get secret "$secret_name" -n "$namespace" -o yaml |
      sed "s/name: $secret_name/name: $backup_secret_name/" |
      kubectl replace --force -f - -n "$namespace"
    echo "Backup secret sikeresen frissítve: $backup_secret_name."
  fi
}

# A függvény használata: backup_secret [namespace] [secret_name]
backup_secret "default" "my-secret"
