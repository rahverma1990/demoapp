import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { GatewayDetailsComponent } from './gateway-details.component';
import {AddActivityComponent} from "./add-activity/add-activity.component";
import {CUSTOM_ELEMENTS_SCHEMA} from "@angular/core";
import {MockBackend} from "@angular/http/testing";
import {BaseRequestOptions, Http} from "@angular/http";
import {ActivatedRoute} from "@angular/router";
import {Observable} from "rxjs";

class MockActivatedRoute extends ActivatedRoute {
  constructor() {
    super(null, null, null, null, null);
    this.params = Observable.of({id: "5"});
  }

describe('GatewayDetailsComponent', () => {
  let component: GatewayDetailsComponent;
  let fixture: ComponentFixture<GatewayDetailsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      providers: [
        MockBackend,
        BaseRequestOptions,
        {
        provide: Http,
        useFactory: (backendInstance: MockBackend, defaultOptions: BaseRequestOptions) => {
          return new Http(backendInstance, defaultOptions);
        },
        deps: [MockBackend, BaseRequestOptions]
      }],
      declarations: [ GatewayDetailsComponent, AddActivityComponent ],
      schemas: [CUSTOM_ELEMENTS_SCHEMA]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(GatewayDetailsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(true).toEqual(true);
  });
});
