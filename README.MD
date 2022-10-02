# Keycloak Javascript providers for OrchestraCities

This repo includes JavaScript Providers used by OrchestraCities
to support multi-tenancy and service Paths:
 
* [Admin only authenticator](scripts/admin-only-authenticator.js): check if user has role `admin` to allow access.
* [Orchestra Cities tenants-roles mapper](scripts/tenants-mapper.js): maps user to tenants and roles within tenants. e.g.:

  ```json
  "tenants": {
    "Tenant1": {
      "roles": [
        "tenant-admin"
      ],
      "groups": [
        "/Admin",
        "/Group1"
      ]
    },
    "Tenant2": {
      "roles": [
        "client2:roleA"
      ],
      "groups": [
        "/Group2"
      ]
    }
  },
  ```

* [Orchestra Cities super-admin mapper](scripts/is-superdamin-mapper.js): create a claim reporting if a user is a super user, e.g.:

  ```json
  "is_super_admin": true,
  ```

Deprecated:

* [Orchestra Cities tenants-name mapper](scripts/tenants-name-mapper.js). See old version.
* [Orchestra Cities fiware services mapper](scripts/services-mapper.js). See old version.

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
