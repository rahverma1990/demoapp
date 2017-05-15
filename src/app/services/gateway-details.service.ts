import { Injectable } from '@angular/core';

import { Http, Headers, RequestOptions, Response, URLSearchParams } from '@angular/http';
import 'rxjs/add/operator/toPromise';

@Injectable()
export class GatewayDetailsService {

  constructor(private http: Http) { }

  getGatewayDetails(): Promise<any> {
    console.log("in service method");
    return this.http.get('../../shared/gateway-details.json').toPromise()
      .then(response => {
        let appsResponse = response.json();
        console.log("in service data");
        console.log(appsResponse);
        return appsResponse ? appsResponse : [];
      });
  }

}
