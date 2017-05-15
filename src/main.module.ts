import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';
import { DigitalGatewayModule } from './app/digital-gateway/digital-gateway.module';

import { GatewayDetailsModule } from './app/gateway-details/gateway-details.module';
import { AppComponent as AppComp} from './app/digital-gateway/components/app/app.component';

@NgModule({
  declarations: [],
  imports: [
    BrowserModule,
    FormsModule,
    DigitalGatewayModule,
    GatewayDetailsModule,
    HttpModule
  ],
  providers: [],
  bootstrap: [AppComp]
})
export class MainModule { }
