#!/bin/bash

backup_secret() {
  local namespace="$1"
  local secret_name="$2"
  local backup_secret_name="${secret_name}.backup"

  echo "Új backup secret létrehozása: $backup_secret_name"

  # Először ellenőrizzük, hogy létezik-e az eredeti secret
  if ! kubectl get secret "$secret_name" -n "$namespace" &> /dev/null; then
    echo "Hiba: A megadott secret ('$secret_name') nem létezik a '$namespace' namespace-ben."
    return 1 # Kilépés hiba kóddal
  fi

  # Megpróbáljuk létrehozni a backup Secret-et
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
