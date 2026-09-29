import { DeviceStatus } from '@smart-tv-remote/shared';
import { TvBrandEntity, TvModelEntity, DiagnosticEventEntity, AppConfigurationEntity } from '../entities/database.entities';

export class BackendDataStore {
  private static instance: BackendDataStore;

  public brands: TvBrandEntity[] = [
    {
      id: 'brand-hikers',
      name: 'Hikers',
      status: 'TESTING',
      createdAt: new Date(),
      updatedAt: new Date(),
    },
    {
      id: 'brand-generic-android',
      name: 'Generic Android TV',
      status: 'SUPPORTED',
      createdAt: new Date(),
      updatedAt: new Date(),
    },
    {
      id: 'brand-samsung',
      name: 'Samsung',
      status: 'SUPPORTED',
      createdAt: new Date(),
      updatedAt: new Date(),
    },
    {
      id: 'brand-lg',
      name: 'LG',
      status: 'SUPPORTED',
      createdAt: new Date(),
      updatedAt: new Date(),
    },
    {
      id: 'brand-sony',
      name: 'Sony',
      status: 'SUPPORTED',
      createdAt: new Date(),
      updatedAt: new Date(),
    },
    {
      id: 'brand-roku',
      name: 'Roku',
      status: 'SUPPORTED',
      createdAt: new Date(),
      updatedAt: new Date(),
    },
  ];

  public models: TvModelEntity[] = [
    {
      id: 'model-hikers-android',
      brandId: 'brand-hikers',
      model: 'Hikers Android Smart TV',
      platform: 'Android TV',
      protocol: 'companion_v1',
      capabilities: {
        power: true,
        volume: true,
        mute: true,
        navigation: true,
        keyboard: true,
        source: true,
      },
      companionRequired: true,
      status: 'TESTING',
      createdAt: new Date(),
      updatedAt: new Date(),
    },
  ];

  public diagnosticEvents: DiagnosticEventEntity[] = [];

  public appConfig: AppConfigurationEntity[] = [
    {
      id: 'config-1',
      configKey: 'min_supported_app_version',
      configValue: '1.0.0',
      updatedAt: new Date(),
    },
    {
      id: 'config-2',
      configKey: 'companion_port_default',
      configValue: '8888',
      updatedAt: new Date(),
    },
  ];

  public static getInstance(): BackendDataStore {
    if (!BackendDataStore.instance) {
      BackendDataStore.instance = new BackendDataStore();
    }
    return BackendDataStore.instance;
  }
}
