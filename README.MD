# Keycloak Javascripts providers for OrchestraCities

Keycloak allows to import auth and mapper scripts from jars:
https://www.keycloak.org/docs/latest/server_development/#_script_providers

In this package you can find:
 
* Admin only authenticator: Check if user has role admin to allow access.
* Orchestra Cities tenants-roles mapper: maps user to tenants and roles within tenants
* Orchestra Cities tenants-name mapper: maps user to tenants' name
* Orchestra Cities fiware services mapper: list services path accessible to users

To load them in keycloak:

```
docker run -d -p 8080:8080 -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin -e "JAVA_TOOL_OPTIONS=-Dkeycloak.profile.feature.scripts=enabled" -v $(pwd):/opt/jboss/keycloak/standalone/deployments/ --name kc jboss/keycloak
```