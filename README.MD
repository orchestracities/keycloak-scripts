# Keycloak Javascript providers for OrchestraCities

This repo includes JavaScript Providers used by OrchestraCities
to support multi-tenancy and service Paths:
 
* [Admin only authenticator](scripts/admin-only-authenticator.js): check if user has role admin to allow access.
* [Orchestra Cities tenants-roles mapper](scripts/tenants-mapper.js): maps user to tenants and roles within tenants
* [Orchestra Cities tenants-name mapper](scripts/tenants-name-mapper.js): maps user to tenants' name
* [Orchestra Cities fiware services mapper](scripts/services-mapper.js): list services path accessible to users

# Building the package

To build the package, simply use:

```sh
sh build.sh
```

it will create a package called `oc-custom.jar`.

Alternatively you can download official builds [here](https://github.com/orchestracities/keycloak-scripts/releases).

# Installing

To deploy the script package in keycloak:
- you need to install the `oc-custom.jar` in the `standalone/deployments` folder
    (see the example in the `test.sh` for docker-based deployment).
- you need to enable the `scripts` feature with the flag
    `-Dkeycloak.profile.feature.scripts=enabled`
    (see the example in the `test.sh` for docker-based deployment).

For more information, check the official [keycloak](https://www.keycloak.org/docs/latest/server_development/#deploy-the-script-jar)
documentation.

# Testing

To load test the scripts in keycloak:

```sh
sh test.sh
```

**NOTE**: if you are using a m1 mac or any other arm64 based computer, you need
to custom build your docker image. E.g.:

```sh
git clone https://github.com/keycloak/keycloak-containers.git
cd keycloak-containers/server
docker build . -t jboss/keycloak
```
