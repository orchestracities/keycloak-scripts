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

#decode admin1 jwt token for client1

echo 'decode admin jwt token for client1'

json=$( curl -sS --location --request POST 'http://localhost:8080/realms/test/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=admin' \
--data-urlencode 'password=admin' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=client1' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

#decode user1 jwt token for client1

echo 'decode user1 jwt token for client1'

json=$( curl -sS --location --request POST 'http://localhost:8080/realms/test/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=user1' \
--data-urlencode 'password=user1' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=client1' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

#decode user2 jwt token for client1

echo 'decode user2 jwt token for client1'

json=$( curl -sS --location --request POST 'http://localhost:8080/realms/test/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=user2' \
--data-urlencode 'password=user2' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=client1' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

#decode admin1 jwt token for client1

echo 'decode admin jwt token for client2'

json=$( curl -sS --location --request POST 'http://localhost:8080/realms/test/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=admin' \
--data-urlencode 'password=admin' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=client2' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

#decode user1 jwt token for client1

echo 'decode user1 jwt token for client2'

json=$( curl -sS --location --request POST 'http://localhost:8080/realms/test/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=user1' \
--data-urlencode 'password=user1' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=client2' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

#decode user2 jwt token for client2

echo 'decode user2 jwt token for client2'

json=$( curl -sS --location --request POST 'http://localhost:8080/realms/test/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=user2' \
--data-urlencode 'password=user2' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=client2' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

echo 'stopping keycloak'

#docker rm kc -f
