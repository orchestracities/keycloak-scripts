#!/bin/sh
echo 'list groups as admin with configuration'

json=$( curl -sS --location --request POST 'http://localhost:8080/realms/default/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=admin' \
--data-urlencode 'password=admin' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=configuration'
 )

#jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

token=$( jq -r ".access_token" <<<"$json" )

curl 'http://localhost:8080/admin/realms/default/groups?briefRepresentation=false' \
  -H 'Accept: application/json, text/plain, */*' \
  -H "Authorization: bearer $token" \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  --compressed | jq .

echo 'list groups as user1 with configuration'

json=$( curl -sS --location --request POST 'http://localhost:8080/realms/default/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=user1' \
--data-urlencode 'password=user1' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=configuration'
 )

#jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

token=$( jq -r ".access_token" <<<"$json" )

curl 'http://localhost:8080/admin/realms/default/groups?briefRepresentation=false' \
  -H 'Accept: application/json, text/plain, */*' \
  -H "Authorization: bearer $token" \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  --compressed | jq .

echo 'list tenat1 group as user1 with configuration'

json=$( curl -sS --location --request POST 'http://localhost:8080/realms/default/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=user1' \
--data-urlencode 'password=user1' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=configuration'
 )

#jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

token=$( jq -r ".access_token" <<<"$json" )

curl 'http://localhost:8080/admin/realms/default/groups/b691f15d-d475-4c9d-97f7-ee8ec18ae262?briefRepresentation=false' \
  -H 'Accept: application/json, text/plain, */*' \
  -H "Authorization: bearer $token" \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  --compressed | jq .

echo 'list groups as user2 with configuration'

json=$( curl -sS --location --request POST 'http://localhost:8080/realms/default/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=user2' \
--data-urlencode 'password=user2' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=configuration'
 )

#jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

token=$( jq -r ".access_token" <<<"$json" )

curl 'http://localhost:8080/admin/realms/default/groups?briefRepresentation=false' \
  -H 'Accept: application/json, text/plain, */*' \
  -H "Authorization: bearer $token" \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  --compressed | jq .
