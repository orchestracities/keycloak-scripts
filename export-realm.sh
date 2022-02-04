#!/bin/sh
docker exec -ti kc /opt/jboss/keycloak/bin/standalone.sh  \
  -Dkeycloak.migration.action=export  \
  -Dkeycloak.migration.provider=singleFile \
  -Dkeycloak.migration.file=/opt/jboss/realm-export.json  \
  -Dkeycloak.migration.realmName=master \
  -Dkeycloak.migration.usersExportStrategy=REALM_FILE \
  -Djboss.socket.binding.port-offset=100

