import { Controller, Get, Post, Body } from '@nestjs/common';
import { BackendDataStore } from '../services/data.store';

@Controller('devices')
export class DevicesController {
  private dataStore = BackendDataStore.getInstance();

  @Get('supported')
  getSupportedTvDatabase() {
    return {
      brands: this.dataStore.brands,
      models: this.dataStore.models,
      count: this.dataStore.models.length,
    };
  }

  @Post('sync')
  syncUserDevices(@Body() body: { userId?: string; savedDevices: any[] }) {
    return {
      success: true,
      syncedAt: new Date().toISOString(),
      deviceCount: body.savedDevices?.length || 0,
    };
  }
}
