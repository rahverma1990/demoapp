import { DigitalGatewayDemoAppPage } from './app.po';

describe('digital-gateway-demo-app App', () => {
  let page: DigitalGatewayDemoAppPage;

  beforeEach(() => {
    page = new DigitalGatewayDemoAppPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
