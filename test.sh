#!/bin/sh

#decode admin1 jwt token for configuration

echo 'decode admin jwt token for configuration'

json=$( curl -sS --location --request POST 'http://localhost:8080/realms/default/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=admin' \
--data-urlencode 'password=admin' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=configuration' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

#decode user1 jwt token for configuration

echo 'decode user1 jwt token for configuration'

json=$( curl -sS --location --request POST 'http://localhost:8080/realms/default/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=user1' \
--data-urlencode 'password=user1' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=configuration' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

#decode user2 jwt token for configuration

echo 'decode user2 jwt token for configuration'

json=$( curl -sS --location --request POST 'http://localhost:8080/realms/default/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=user2' \
--data-urlencode 'password=user2' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=configuration' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

#decode admin1 jwt token for ngsi

echo 'decode admin jwt token for ngsi'

json=$( curl -sS --location --request POST 'http://localhost:8080/realms/default/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=admin' \
--data-urlencode 'password=admin' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=ngsi' \
--data-urlencode 'client_secret=wWUO65Xa1zyBlTdaYaJ8TCqyBvYa3oi0' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

#decode user1 jwt token for configuration

echo 'decode user1 jwt token for ngsi'

json=$( curl -sS --location --request POST 'http://localhost:8080/realms/default/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=user1' \
--data-urlencode 'password=user1' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=ngsi' \
--data-urlencode 'client_secret=wWUO65Xa1zyBlTdaYaJ8TCqyBvYa3oi0' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

#decode user2 jwt token for ngsi

echo 'decode user2 jwt token for ngsi'

json=$( curl -sS --location --request POST 'http://localhost:8080/realms/default/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=user2' \
--data-urlencode 'password=user2' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=ngsi' \
--data-urlencode 'client_secret=wWUO65Xa1zyBlTdaYaJ8TCqyBvYa3oi0' )

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

echo 'stopping keycloak'
#docker rm kc -f
