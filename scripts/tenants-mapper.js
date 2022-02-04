var HashMap = Java.type('java.util.HashMap');
var HashSet = Java.type('java.util.HashSet');
var ArrayList = Java.type('java.util.ArrayList');
var ModelToRepresentation = Java.type('org.keycloak.models.utils.ModelToRepresentation');
var groups = user.getGroups();
var tenants = new ArrayList();

groups.forEach(scanTenant);
groups.forEach(scanGroups);

function scanTenant(group){
    if ( isTenant(group)===true ) {
        found = getTenant(group.getName());
        if ( !found ) {
            var groups = new ArrayList();
            var tenant = new HashMap();
            tenant.put("id",group.getId());
            tenant.put("name",group.getName());
            tenant.put("groups",groups);
            tenants.add(tenant);
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
            current = getGroup(groups, group.getName());
            if (! current && !isServicePath(group)){
                var newGroup = new HashMap();
                newGroup.put("id",group.getId());
                newGroup.put("name", group.getName());
                var rep = ModelToRepresentation.toRepresentation(group, true);
                if (rep.getRealmRoles())
                    newGroup.put("realmRoles",rep.getRealmRoles());
                if( keycloakSession.getContext().getClient()){
                    var clientId = keycloakSession.getContext().getClient().getClientId();
                    if(rep.getClientRoles().get(clientId)) newGroup.put("clientRoles",rep.getClientRoles().get(clientId));
                } else {
                    var clients = realm.getClients();
                     for (i= 0; i<clients.size(); i++){
                        item = clients.get(i);
                        var clientId = item.getClientId();
                        if(rep.getClientRoles().get(clientId)) newGroup.put(clientId,rep.getClientRoles().get(clientId));
                    }
                }
                groups.add(newGroup);
            }
        }
    } 
    if( group.getParent() !== null ) {
        scanGroups(group.getParent());
    }
}

function getTenant(name){
    for (i= 0; i<tenants.size(); i++){
        item = tenants.get(i);
        if (item.get("name")===name)
            return item;
    }
    return null;
}

function getGroup(groups, name){
    for (i= 0; i<groups.size(); i++){
        item = groups.get(i);
        if (item.get("name")===name)
            return item;
    }
    return null;
}

function getRoot(group){
    if(group.getParent() !== null) 
        return getRoot(group.getParent());
    return group;
}


function isServicePath(group){
    if (group.getFirstAttribute("servicePath") == "true" || group.getFirstAttribute("servicepath") == "true")  
        return true;
    return false;
}

function isTenant(group){
    if (group.getParent()===null && 
        group.getFirstAttribute("tenant") == "true"){
        return true;
    }
    return false;
}

token.setOtherClaims("tenants", tenants);