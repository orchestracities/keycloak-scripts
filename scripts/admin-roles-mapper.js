var HashMap = Java.type('java.util.HashMap');
var HashSet = Java.type('java.util.HashSet');
var ArrayList = Java.type('java.util.ArrayList');
var ModelToRepresentation = Java.type('org.keycloak.models.utils.ModelToRepresentation');
var rep = ModelToRepresentation.toRepresentation(user, true);
var roles= rep.getRealmRoles();
var adminRoles = new ArrayList();

roles.forEach(scanTenant);
groups.forEach(scanGroups);

function scanRoles(role){
    if ( role.getName()==='admin' ) {
      adminRoles.add(role.getName());
    }
}

token.setOtherClaims("admin-roles", adminRoles);
