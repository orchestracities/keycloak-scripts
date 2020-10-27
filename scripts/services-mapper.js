var HashMap = Java.type('java.util.HashMap');
var HashSet = Java.type('java.util.HashSet');
var ModelToRepresentation = Java.type('org.keycloak.models.utils.ModelToRepresentation');
var groups = user.getGroups();
var services = new HashMap();

groups.forEach(scanTenant);
groups.forEach(scanServicePath);

function scanTenant(group){
    if ( isTenant(group)===true ) {
        if ( services.get(group.getName()) === null ) {
            var servicePath = new HashSet();
            services.put(group.getName(), servicePath);
        }
    } else if( group !== null && group.getParent() !== null ) {
        scanTenant(group.getParent());
    }
}

function scanServicePath(group){
    if ( isServicePath(group)===true ) {
        if ( services.get(getRoot(group).getName()) ){
            var servicePath = Java.type('java.util.HashSet');
            servicePath = services.get(getRoot(group).getName()) ;
            var fullServicePath = ModelToRepresentation.buildGroupPath(group).substring(("/"+getRoot(group).getName()).length);
            servicePath.add(fullServicePath);
        }
    } 
    if( group.getParent() !== null ) {
        scanServicePath(group.getParent());
    }
}

function getRoot(group){
    if(group.getParent() !== null) 
        return getRoot(group.getParent());
    return group;
}


function isServicePath(group){
    if (group.getFirstAttribute("servicePath") == "true")  
        return true;
    return false;
}

function isTenant(group){
    if (group.getParent()===null && 
        group.getFirstAttribute("tenant") == "true"){
        if (services.get(group.getName()) === null) {
            var servicePath = new HashSet();
            services.put(group.getName(), servicePath);
        }
        return true;
    }
    return false;
}

token.setOtherClaims("fiware-services", services);