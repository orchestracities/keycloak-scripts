/**
 * return a boolean claim structured as:
 *  "is_super_admin": false
 */

isSuperAdmin = false;

if(user.hasRole(realm.getRole("admin"))){
  isSuperAdmin = true;
}

token.setOtherClaims("is_super_admin", isSuperAdmin);
