export interface GatewayModel {
  id: Number;
  name: String;
  description: String;
  type: String;
  version: String;
  policies: {
    requestPolicy: Array<Object>,
    responsePolicy: Array<Object>
  };
}
