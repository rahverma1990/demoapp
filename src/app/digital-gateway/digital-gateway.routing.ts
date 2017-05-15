import { ModuleWithProviders } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AppListComponent } from '../gateway-list/gateway-list.component';

export const appRoutes: Routes = [
  // {
  //   path: 'flows/:id',
  //   canActivate: [ ConfigurationLoadedGuard ],
  //   //name:"FlogoFlowDetail",
  //   loadChildren: '/app/flogo.flows.detail/flogo.flows.detail.module#FlogoFlowsDetailModule'
  // }
    {
        path: '',
        redirectTo: '/link1',
        pathMatch: 'full'
    },
    {
        path: 'link1',
        component: AppListComponent
    }
    // {
    //     path: '',
    //     redirectTo : 'link1'
    // }
];

export const routing: ModuleWithProviders = RouterModule.forRoot(appRoutes);
