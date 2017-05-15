import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { GatewayDetailsComponent } from './component/gateway-details.component';
const routes: Routes = [
  {
    path: 'link1/:id',
    component: GatewayDetailsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
  providers: []
})
export class GatewayDetailsRoutingModule { }
