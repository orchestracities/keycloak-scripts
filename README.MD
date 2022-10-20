# Keycloak Javascript providers for OrchestraCities

This repo includes JavaScript Providers used by OrchestraCities
to support multi-tenancy and service Paths:
 
* [Orchestra Cities tenants-roles mapper](scripts/tenants-mapper.js): maps user to tenants and roles within tenants. e.g.:

  ```json
  "tenants": {
    "Tenant2": {
      "roles": [
        "tenant-admin",
        "ngsi:entity:op",
        "ngsi:subscription:read",
        "ngsi:registration:write",
        "ngsi:entity:read",
        "ngsi:registration:delete",
        "ngsi:subscription:write",
        "ngsi:registration:read",
        "ngsi:subscription:delete",
        "ngsi:entity:write",
        "ngsi:entity:delete"
      ],
      "groups": [
        "/Admin2",
        "/Group2"
      ],
      "id": "a6662e3f-0328-43d1-b5cf-25f3209c57e8"
    }
  }
  ```

* [Orchestra Cities super-admin mapper](scripts/is-superdamin-mapper.js): create a claim reporting if a user is a super user, e.g.:

  ```json
  "is_super_admin": true,
  ```

Deprecated:

* [Orchestra Cities tenants-name mapper](scripts/tenants-name-mapper.js). See old version.
* [Orchestra Cities fiware services mapper](scripts/services-mapper.js). See old version.
* [Admin only authenticator](scripts/admin-only-authenticator.js). See old version.
  This not more needed since oauth-proxy allows to validate roles and groups.

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
    (see the example in the `test.sh` for docker-based deployment)
    or using the preview [profile](https://www.keycloak.org/docs/latest/server_installation/#profiles).

For more information, check the official [keycloak](https://www.keycloak.org/docs/latest/server_development/#deploy-the-script-jar)
documentation.

# Testing

Requirements:
- docker
- curl
- jq

To load test the scripts in keycloak:

```sh
sh test.sh
```

## Updating realm export

Should you need to update the example realm, you can export a new updated version launching the following script:

```sh
sh export-realm.sh
```

Once the export is completed type `CTRL+C` to exit from the container.
