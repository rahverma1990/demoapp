import { Component, OnInit } from '@angular/core';
import { GatewayDetails } from '../common/interfaces'

@Component({
  selector: 'dg-app-list',
  templateUrl: './gateway-list.component.html',
  styleUrls: ['./gateway-list.component.sass']
})
export class AppListComponent implements OnInit {

  public gateways = [];
  gatewayDetails: GatewayDetails = {
        id:"",
        name : "",
        type:"",
        version:"0.0.1",
        description:"",
        policies : {
            requestPolicy : [],
            responsePolicy : []
        },
      date : new Date()
  };
  addGateway(appDetails) {
      console.log(appDetails);
      appDetails = JSON.parse(appDetails);
      var d = new Date();
      appDetails.date = d;
      this.gateways.unshift(appDetails);
      localStorage.setItem('gatewayList', JSON.stringify(this.gateways));
      console.log('localstorage ',localStorage.getItem('gatewayList'));
  }
    deleteGateway(app){
        console.log('delete called');
        var index = this.gateways.findIndex(x => x.name == app.name);
        this.gateways.splice(index, 1);
        localStorage.setItem('gatewayList', JSON.stringify(this.gateways));
    }
  constructor() { }

  ngOnInit() {

      // this.gateways = JSON.parse(localStorage.getItem('appList'));
    // this.gateways = localStorage.setItem('appList', JSON.stringify([{name : 'test', desc : 'XYZ'}]);

      this.gateways = JSON.parse(localStorage.getItem('gatewayList'))||[];

  }

}
