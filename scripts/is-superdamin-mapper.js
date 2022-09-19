var client = keycloakSession.getContext().getClient();
var forEach = Array.prototype.forEach;

var isAdmin = false;

forEach.call(user.getRealmRoleMappings().toArray(), function (roleModel) {
 if (roleModel.getName().contains("admin")) {
    isAdmin = true;
  }
});

if (isAdmin) {
  token.getOtherClaims().put("superadmin", "true");
} else {
  token.getOtherClaims().put("superadmin", "false");
}
