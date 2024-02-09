#!/bin/bash

# A namespace beállítása, ahol a szekrétek létre lesznek hozva
NAMESPACE=default

# A secretek száma
SECRET_COUNT=10

for i in $(seq 1 $SECRET_COUNT); do
  # Generál egy random stringet a szekret nevének és tartalmának
  SECRET_NAME="random-secret-$i"
  RANDOM_VALUE=$(openssl rand -base64 32)

  # Létrehoz egy szekretet a generált értékekkel
  kubectl create secret generic $SECRET_NAME --from-literal=password=$RANDOM_VALUE -n $NAMESPACE
  
  echo "Secret $SECRET_NAME created with random value."
done
