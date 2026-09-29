import { Module, Controller, Get } from '@nestjs/common';
import { COMPANION_SERVICE_TYPE, PROTOCOL_VERSION } from '@smart-tv-remote/shared';
import { BrandsController } from './controllers/brands.controller';
import { DevicesController } from './controllers/devices.controller';
import { DiagnosticsController } from './controllers/diagnostics.controller';
import { AppConfigController } from './controllers/config.controller';

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

@Module({
  imports: [],
  controllers: [
    HealthController,
    BrandsController,
    DevicesController,
    DiagnosticsController,
    AppConfigController,
  ],
  providers: [],
})
export class AppModule {}
