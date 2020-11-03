/**
 * Available variables:
 * user - the current user
 * realm - the current realm
 * token - the current token
 * userSession - the current userSession
 * keycloakSession - the current userSession
 */


var clientId = keycloakSession.getContext().getClient().getClientId();



token.setOtherClaims("client_check", clientId);
//insert your code here...
