#!/bin/bash

NAMESPACE="cluster-ops"
PREFIX="ldap-group-syncer-dockercfg-"
BATCH_SIZE=500

while : ; do
  # Obtener un lote de secretos
  SECRETS=$(oc get secrets -n $NAMESPACE --no-headers -o custom-columns=":metadata.name" | grep "^$PREFIX" | head -n $BATCH_SIZE)

  # Si no hay más secretos que eliminar, salir del bucle
  if [ -z "$SECRETS" ]; then
    echo "No more secrets to delete."
    break
  fi

  # Eliminar el lote de secretos
  echo "$SECRETS" | xargs -I {} oc delete secret {} -n $NAMESPACE

  # Esperar un momento antes de continuar (opcional, para evitar sobrecargar el sistema)
  sleep 1
done
