#!/bin/sh
docker exec -ti kc /opt/keycloak/bin/kc.sh export --file /opt/keycloak/data/export/realm-export-empty.json --realm default
