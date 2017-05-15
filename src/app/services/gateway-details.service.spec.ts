import { TestBed, inject } from '@angular/core/testing';

import { GatewayDetailsService } from './gateway-details.service';

describe('GatewayDetailsService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [GatewayDetailsService]
    });
  });

  it('should ...', inject([GatewayDetailsService], (service: GatewayDetailsService) => {
    expect(service).toBeTruthy();
  }));
});
