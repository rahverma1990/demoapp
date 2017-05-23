import {Component, Input, OnInit} from '@angular/core';

import { GatewayDetailsService } from '../../services/gateway-details.service';
import {GatewayModel} from '../../models/gateway-model';
import {ActivatedRoute} from "@angular/router";

@Component({
  selector: 'dg-gateway-details',
  moduleId: module.id,
  templateUrl: './gateway-details.component.html',
  styleUrls: ['./gateway-details.component.css'],
  providers: [GatewayDetailsService]
})
export class GatewayDetailsComponent implements OnInit {
  isListVisible: Boolean;
  gatewayDetails: GatewayModel;
  constructor(private _GatewayDetailsService: GatewayDetailsService, private router: ActivatedRoute) {

  }
 id: String;

  ngOnInit() {
    // this._GatewayDetailsService.getGatewayDetails()
    //   .then((data: any) => {
    //   this.gatewayDetails = data;
    //     console.log(this.gatewayDetails);
    // });
    this.router.params.subscribe(params => {
      this.id = params['id']; // (+) converts string 'id' to a number
      console.log(JSON.parse(localStorage.getItem('gatewayList')));
      this.gatewayDetails = JSON.parse(localStorage.getItem('gatewayList')).find(x => x.id === this.id);
      console.log(this.id);
      console.log(this.gatewayDetails);
      // In a real app: dispatch action to load the details here.
    });

  }

 policyRequest(item) {
    this.gatewayDetails.policies.requestPolicy.push(item);
    console.log('added policy');
    console.log(JSON.stringify(this.gatewayDetails));

 }
  policyResponse(item) {
    this.gatewayDetails.policies.responsePolicy.push(item);
    console.log('added policy');
    console.log(JSON.stringify(this.gatewayDetails));

  }
  policyPop(item) {
    var x = this.gatewayDetails.policies.requestPolicy.indexOf(item);
    this.gatewayDetails.policies.requestPolicy.splice(x, 1);
    console.log('removed');
    console.log(JSON.stringify(this.gatewayDetails));
  }
}
