import { Module, Controller, Get } from '@nestjs/common';
import { COMPANION_SERVICE_TYPE, PROTOCOL_VERSION } from '@smart-tv-remote/shared';

@Controller('health')
export class HealthController {
  @Get()
  check() {
    return {
      status: 'ok',
      service: 'smart-tv-remote-api',
      protocolVersion: PROTOCOL_VERSION,
      companionServiceType: COMPANION_SERVICE_TYPE,
      timestamp: new Date().toISOString(),
    };
  }
}

@Controller('brands')
export class BrandsController {
  @Get()
  getBrands() {
    return [
      {
        id: 'brand-hikers',
        name: 'Hikers',
        status: 'TESTING',
        notes: 'Target brand. Verified capability fallback via TV companion app.',
      },
      {
        id: 'brand-generic-android',
        name: 'Generic Android TV',
        status: 'SUPPORTED',
      },
    ];
  }
}

@Module({
  imports: [],
  controllers: [HealthController, BrandsController],
  providers: [],
})
export class AppModule {}
