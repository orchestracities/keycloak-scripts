/**
 * return a JSON claim structured as:
 *  "tenants": {
 *    "Tenant2": {
 *      "roles": [
 *        "tenant-admin",
 *        "ngsi:entity:op",
 *        "ngsi:subscription:read",
 *        "ngsi:registration:write",
 *        "ngsi:entity:read",
 *        "ngsi:registration:delete",
 *        "ngsi:subscription:write",
 *        "ngsi:registration:read",
 *        "ngsi:subscription:delete",
 *        "ngsi:entity:write",
 *        "ngsi:entity:delete"
 *      ],
 *      "groups": [
 *        "/Admin2",
 *        "/Group2"
 *      ],
 *      "id": "a6662e3f-0328-43d1-b5cf-25f3209c57e8"
 *    }
 *  },
 * TODO: enable filter tenant using scope tenant:tenantId
 * TODO: enable return only tenant lists using scope only-tenants
 * TODO: return derived roles
 */

var HashMap = Java.type('java.util.HashMap');
var HashSet = Java.type('java.util.HashSet');
var ArrayList = Java.type('java.util.ArrayList');
var ModelToRepresentation = Java.type('org.keycloak.models.utils.ModelToRepresentation');
var groups = user.getGroups();
var tenants = new HashMap();

groups.forEach(scanTenant);
groups.forEach(scanGroups);

function scanTenant(group){
    if ( isTenant(group)===true ) {
        found = getTenant(group.getName());
        if ( !found ) {
            var groups = new ArrayList();
            var roles = new ArrayList();
            var tenantConfiguration = new HashMap();
            tenantConfiguration.put("groups",groups);
            tenantConfiguration.put("roles",roles);
            tenantConfiguration.put("id", group.getId());
            tenants.put(group.getName(),tenantConfiguration);
        }
    } else if( group !== null && group.getParent() !== null ) {
        scanTenant(group.getParent());
    }
}

function scanGroups(group){
    if ( isTenant(group)===false )  {
        found = getTenant(getRoot(group).getName());
        if ( found ) {
            groups = found[1].get("groups");
            roles = found[1].get("roles");
            var rep = ModelToRepresentation.toRepresentation(group, true);
            var cleanPath = rep.getPath().substring(found[0].length + 1);
            current = getGroup(groups, cleanPath);
            if (! current ){
                groups.add(cleanPath);
                if (rep.getRealmRoles())
                    addToArrayList(rep.getRealmRoles(), roles, "");
                // if( keycloakSession.getContext().getClient()){
                //     var clientId = keycloakSession.getContext().getClient().getClientId();
                //     if(rep.getClientRoles().get(clientId)) addToArrayList(rep.getClientRoles().get(clientId), roles, clientId);
                // } else {
                var clients = realm.getClients();
                for (i= 0; i<clients.size(); i++){
                    item = clients.get(i);
                    var clientId = item.getClientId();
                    var clientRoles = rep.getClientRoles().get(clientId);
                    if(clientRoles !=  null) addToArrayList(clientRoles, roles, clientId);
                }
            }
        }
    }
    if( group.getParent() !== null ) {
        scanGroups(group.getParent());
    }
}

function getTenant(name){
    if (name in tenants){
        return [name, tenants[name]];
    }
    return null;
}

function getGroup(groups, name){
    for (i= 0; i<groups.size(); i++){
        item = groups.get(i);
        if (item===name)
            return item;
    }
    return null;
}

function getRoot(group){
    if(group.getParent() !== null) 
        return getRoot(group.getParent());
    return group;
}

function isTenant(group){
    if (group.getParent()===null && 
        group.getFirstAttribute("tenant") == "true"){
        return true;
    }
    return false;
}

function addToArrayList(source, destination, clientid){
    for (var i = 0; i < source.size(); i++){
      if (clientid != "" &&  !destination.contains(clientid + ":" + source.get(i))) {
        destination.add(clientid + ":" + source.get(i));
      } else if (clientid == "" &&  !destination.contains(source.get(i))) {
        destination.add(source.get(i));
      }
    }
}

token.setOtherClaims("tenants", tenants);
