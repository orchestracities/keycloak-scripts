#!/bin/sh
docker exec -ti kc /opt/keycloak/bin/kc.sh export --file /opt/keycloak/data/import/realm-export.json --realm test
