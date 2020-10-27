var HashMap = Java.type('java.util.HashMap');
var HashSet = Java.type('java.util.HashSet');
var ArrayList = Java.type('java.util.ArrayList');
var ModelToRepresentation = Java.type('org.keycloak.models.utils.ModelToRepresentation');
var groups = user.getGroups();
var tenants = new ArrayList();

groups.forEach(scanTenant);

function scanTenant(group){
    if ( isTenant(group)===true ) {
        found = getTenant(group.getName());
        if ( !found ) {
            tenants.add(group.getName());
        }
    } else if( group !== null && group.getParent() !== null ) {
        scanTenant(group.getParent());
    }
}

function getTenant(name){
    for (i= 0; i<tenants.size(); i++){
        item = tenants.get(i);
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

token.setOtherClaims("tenants", tenants);