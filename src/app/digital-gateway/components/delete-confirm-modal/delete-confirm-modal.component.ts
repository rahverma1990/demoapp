import { Component, OnInit, ViewChild, Output, EventEmitter } from '@angular/core';
import { ModalComponent } from 'ng2-bs3-modal/ng2-bs3-modal';

@Component({
  selector: 'dg-delete-confirm-modal',
  templateUrl: './delete-confirm-modal.component.html',
  styleUrls: ['./delete-confirm-modal.component.sass']
})
export class DeleteConfirmModalComponent implements OnInit {
    @ViewChild('deleteModal')
    modal: ModalComponent;

    @Output()
    deleteGateway:EventEmitter<string> = new EventEmitter();

    delGateway() {
        this.deleteGateway.emit();
        this.modal.dismiss();
    }
    close() {
        this.modal.close();
    }
    open() {
        this.modal.open();
    }
    constructor() {

    }

    ngOnInit() {
    }

}