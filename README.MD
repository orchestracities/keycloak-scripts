# Keycloak Javascript providers for OrchestraCities

This repo includes JavaScript Providers used by OrchestraCities
to support multi-tenancy and service Paths:
 
* [Admin only authenticator](scripts/admin-only-authenticator.js): check if user has role admin to allow access.
* [Orchestra Cities tenants-roles mapper](scripts/tenants-mapper.js): maps user to tenants and roles within tenants. e.g.:

  ```json
  "tenants": [
    {
      "name": "Tenant1",
      "groups": [
        {
          "realmRoles": [],
          "name": "Group1",
          "id": "57369209-ae5c-49c1-bac7-82c16c3029bf",
          "clientRoles": [
            "role1"
          ]
        }
      ],
      "id": "b691f15d-d475-4c9d-97f7-ee8ec18ae262"
    },
    {
      "name": "Tenant2",
      "groups": [
        {
          "realmRoles": [],
          "name": "Group2",
          "id": "9b2c2c3e-e3cd-4758-9e14-b005feef06f1",
          "clientRoles": [
            "role2"
          ]
        }
      ],
      "id": "a6662e3f-0328-43d1-b5cf-25f3209c57e8"
    }
  ],
  ```

* [Orchestra Cities tenants-name mapper](scripts/tenants-name-mapper.js): maps user to tenants' name. e.g.:

  ```json
  "tenants": [
    "Tenant1",
    "Tenant2"
  ],
  ```

* [Orchestra Cities fiware services mapper](scripts/services-mapper.js): list services path accessible to users. e.g.:

  ```json
  "fiware-services": {
    "Tenant1": [
      "/ServicePath1"
    ],
    "Tenant2": [
      "/ServicePath2"
    ]
  },
  ```

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

**NOTE**: if you are using a m1 mac or any other arm64 based computer, you need
to custom build your docker image. E.g.:

```sh
git clone https://github.com/keycloak/keycloak-containers.git
cd keycloak-containers/server
docker build . -t jboss/keycloak
```

## Updating realm export

Should you need to update the example realm, you can export a new updated version launching the following script:

```sh
sh export-realm.sh
```

Once the export is completed type `CTRL+C` to exit from the container.
