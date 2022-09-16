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
            var realmRoles = new ArrayList();
            var clientRoles = new ArrayList();
            var tenantConfiguration = new HashMap();
            tenantConfiguration.put("groups",groups);
            tenantConfiguration.put("realmRoles",realmRoles);
            tenantConfiguration.put("clientRoles",clientRoles);
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
            groups = found.get("groups");
            realmRoles = found.get("realmRoles");
            clientRoles = found.get("clientRoles");
            current = getGroup(groups, group.getName());
            if (! current ){
                //we should put the group to show the hierarchy
                groups.add(group.getName());
                var rep = ModelToRepresentation.toRepresentation(group, true);
                if (rep.getRealmRoles())
                    addToArrayList(rep.getRealmRoles(), realmRoles);
                if( keycloakSession.getContext().getClient()){
                    var clientId = keycloakSession.getContext().getClient().getClientId();
                    if(rep.getClientRoles().get(clientId)) addToArrayList(rep.getClientRoles().get(clientId), clientRoles);
                } else {
                    var clients = realm.getClients();
                    for (i= 0; i<clients.size(); i++){
                        item = clients.get(i);
                        var clientId = item.getClientId();
                        if(rep.getClientRoles().get(clientId)) {
                            foundClient = found.get(clientId);
                            if (!foundClient) 
                              found.put(clientId,rep.getClientRoles().get(clientId));
                        }
                    }
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
            return tenants[name];
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

function addToArrayList(source, destination){
    for (i = 0; i < source.size(); i++){
      if (!destination.contains(source.get(i))) {
        destination.add(source.get(i));
      }
    }
    return destination;
}

token.setOtherClaims("tenants", tenants);