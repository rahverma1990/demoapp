import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { GatewayDetailsRoutingModule } from './gateway-details-routing.module';
import { GatewayDetailsComponent } from './component/gateway-details.component';
import { AddActivityComponent } from './component/add-activity/add-activity.component';
import { ListActivitiesComponent } from './component/list-activities/list-activities.component';

@NgModule({
  imports: [
    CommonModule,
    GatewayDetailsRoutingModule
  ],
  declarations: [GatewayDetailsComponent, AddActivityComponent, ListActivitiesComponent]
})
export class GatewayDetailsModule { }
