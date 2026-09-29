import { Controller, Get } from '@nestjs/common';
import { BackendDataStore } from '../services/data.store';

@Controller('config')
export class AppConfigController {
  private dataStore = BackendDataStore.getInstance();

  @Get()
  getAppConfiguration() {
    return {
      configs: this.dataStore.appConfig,
      serverTime: new Date().toISOString(),
    };
  }
}
