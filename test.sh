#!/bin/sh
echo 'build scripts'
mkdir deployments
sh build.sh
mv oc-custom.jar deployments

echo 'start keycloak'
docker run -d -p 8080:8080 \
  -e KEYCLOAK_USER=admin  \
  -e KEYCLOAK_PASSWORD=admin  \
  -e "JAVA_TOOL_OPTIONS=-Dkeycloak.profile.feature.scripts=enabled -Dkeycloak.migration.action=import -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.file=/opt/jboss/realm-export.json -Dkeycloak.migration.strategy=OVERWRITE_EXISTING" \
  -v $(pwd)/deployments/oc-custom.jar:/opt/jboss/keycloak/standalone/deployments/oc-custom.jar  \
  -v $(pwd)/realm-export.json:/opt/jboss/realm-export.json \
  --name kc \
  jboss/keycloak


while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:8080)" != "200" ]]; do sleep 5; done

echo 'keycloak is running'

#decode admin1 jwt token for client1

echo 'decode user1 jwt token for client1'

json=$( curl -sS --location --request POST 'http://localhost:8080/auth/realms/master/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=admin' \
--data-urlencode 'password=admin' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=client1' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

#decode user1 jwt token for client1

echo 'decode user1 jwt token for client1'

json=$( curl -sS --location --request POST 'http://localhost:8080/auth/realms/master/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=user1' \
--data-urlencode 'password=user1' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=client1' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

#decode user2 jwt token for client1

echo 'decode user2 jwt token for client1'

json=$( curl -sS --location --request POST 'http://localhost:8080/auth/realms/master/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=user2' \
--data-urlencode 'password=user2' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=client1' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

#decode admin1 jwt token for client1

echo 'decode user1 jwt token for client2'

json=$( curl -sS --location --request POST 'http://localhost:8080/auth/realms/master/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=admin' \
--data-urlencode 'password=admin' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=client2' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

#decode user1 jwt token for client1

echo 'decode user1 jwt token for client2'

json=$( curl -sS --location --request POST 'http://localhost:8080/auth/realms/master/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=user1' \
--data-urlencode 'password=user1' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=client2' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

#decode user2 jwt token for client2

echo 'decode user2 jwt token for client2'

json=$( curl -sS --location --request POST 'http://localhost:8080/auth/realms/master/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=user2' \
--data-urlencode 'password=user2' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=client2' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

echo 'stopping keycloak'

docker rm kc -f
