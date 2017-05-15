import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
// import { RouterModule }   from '@angular/router';
import { HeaderComponent } from '../header/header.component';
import { FooterComponent } from '../footer/footer.component';
import { AppListComponent } from '../gateway-list/gateway-list.component';
import { AppComponent } from './components/app/app.component';
import { routing } from "./digital-gateway.routing";
import { FormsModule } from '@angular/forms';
import { Ng2Bs3ModalModule } from 'ng2-bs3-modal/ng2-bs3-modal';
import { AddGatewayModalComponent } from './components/add-Gateway-modal/add-Gateway-modal.component';
import { DeleteConfirmModalComponent } from './components/delete-confirm-modal/delete-confirm-modal.component';
@NgModule({
  imports: [
    CommonModule,
    routing,
    FormsModule,
    Ng2Bs3ModalModule
  ],
  declarations: [
      AppComponent,
      HeaderComponent,
      FooterComponent,
      AppListComponent,
      AddGatewayModalComponent,
      DeleteConfirmModalComponent
  ],
  entryComponents : [
      AddGatewayModalComponent
  ],
  bootstrap: [AppComponent]
})
export class DigitalGatewayModule { }
