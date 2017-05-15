export interface GatewayDetails {

    id: string;
    name: string;
    type: string;
    version: string;
    description: string;
    policies: {
        requestPolicy: Array<Object>,
        responsePolicy: Array<Object>
    };
    date: Date;
}

