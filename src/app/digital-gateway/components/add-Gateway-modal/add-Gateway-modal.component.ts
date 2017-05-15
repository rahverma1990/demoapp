import { Component, OnInit, ViewChild, Input, Output, EventEmitter } from '@angular/core';
// import { FormGroup, FormBuilder, Validators, AbstractControl } from '@angular/forms';
import { ModalComponent } from 'ng2-bs3-modal/ng2-bs3-modal';
import { GatewayDetails } from '../../../common/interfaces'

@Component({
  selector: 'dg-add-Gateway-modal',
  templateUrl: './add-Gateway-modal.component.html',
  styleUrls: ['./add-Gateway-modal.component.sass']
})
export class AddGatewayModalComponent implements OnInit {
    @ViewChild('myModal')
    modal: ModalComponent;

    @Input()
    gatewayDetails;

    @Input()
    gateways;
    // public gateway:FormGroup

    @Output()
    addGateway = new EventEmitter();

    addedGateway(details) {
        var gatewayDetails: GatewayDetails = {
            id:details.id,
            name : "",
            type:"",
            version:"0.0.1",
            description:details.description,
            date: details.date,
            policies : {
                requestPolicy : [],
                responsePolicy : []
            }
        };
        console.log('gatewaydetails', gatewayDetails);
        this.addGateway.emit(JSON.stringify(gatewayDetails));
        this.modal.dismiss();
    }
    close() {
        this.modal.close();
    }
    open() {
        this.gatewayDetails = {};
        this.unique = true;
        console.log(this.gateways);
        this.modal.open();
    }
    unique = true;
    checkForUnique(id){
        console.log(id);
        for(var i =0; i < this.gateways.length;i++){
            console.log();
            if(this.gateways[i].id === id){
                this.unique = false;
            }
        }
        console.log(this.unique);
    }
  constructor() {

  }

  ngOnInit() {
  }

}
