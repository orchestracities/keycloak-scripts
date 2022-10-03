#!/bin/sh
echo 'build scripts'
mkdir deployments
sh build.sh
mv oc-custom.jar deployments

echo 'start keycloak'
docker run -d -p 8080:8080 \
  -e KEYCLOAK_ADMIN=admin  \
  -e KEYCLOAK_ADMIN_PASSWORD=admin  \
  -e KC_FEATURES=scripts  \
  -v $(pwd)/deployments/oc-custom.jar:/opt/keycloak/providers/oc-custom.jar  \
  -v $(pwd)/realm-export.json:/opt/keycloak/data/import/realm-export.json \
  --name kc \
  quay.io/keycloak/keycloak:19.0.1 \
  start-dev --import-realm


while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:8080)" != "200" ]]; do sleep 5; done

echo 'keycloak is running'
