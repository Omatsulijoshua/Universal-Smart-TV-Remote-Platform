import { DeviceStatus } from '@smart-tv-remote/shared';

export interface AdminBrand {
  id: string;
  name: string;
  logo?: string;
  status: DeviceStatus;
  createdAt?: string;
}

export interface AdminModel {
  id: string;
  brandId: string;
  model: string;
  platform: 'Android TV' | 'Google TV' | 'Tizen' | 'webOS' | 'Roku' | 'Proprietary';
  protocol: string;
  capabilities: {
    navigation: boolean;
    volume: boolean;
    mute: boolean;
    keyboard: boolean;
    media: boolean;
    powerOn: boolean;
    powerOff: boolean;
  };
  companionRequired: boolean;
  status: DeviceStatus;
}

export interface AdminProtocol {
  id: string;
  name: string;
  code: string;
  defaultPort: number;
  transportType: string;
  pairingRequired: boolean;
}

export interface AdminDiagnosticEvent {
  id: string;
  phoneDeviceId: string;
  tvDeviceId?: string;
  eventType: string;
  transport: string;
  success: boolean;
  latencyMs?: number;
  createdAt: string;
}

export class AdminDashboardService {
  private brands: AdminBrand[] = [
    { id: 'brand-hikers', name: 'Hikers', status: DeviceStatus.TESTING, createdAt: '2026-09-28' },
    { id: 'brand-generic-android', name: 'Generic Android TV', status: DeviceStatus.SUPPORTED, createdAt: '2026-09-28' },
    { id: 'brand-samsung', name: 'Samsung', status: DeviceStatus.SUPPORTED, createdAt: '2026-09-28' },
    { id: 'brand-lg', name: 'LG', status: DeviceStatus.SUPPORTED, createdAt: '2026-09-28' },
    { id: 'brand-sony', name: 'Sony', status: DeviceStatus.SUPPORTED, createdAt: '2026-09-28' },
    { id: 'brand-roku', name: 'Roku', status: DeviceStatus.SUPPORTED, createdAt: '2026-09-28' },
  ];

  private models: AdminModel[] = [
    {
      id: 'model-hikers-32',
      brandId: 'brand-hikers',
      model: 'Hikers Android Smart TV 32"',
      platform: 'Android TV',
      protocol: 'companion_v1',
      capabilities: {
        navigation: true,
        volume: true,
        mute: true,
        keyboard: true,
        media: true,
        powerOn: false,
        powerOff: true,
      },
      companionRequired: true,
      status: DeviceStatus.TESTING,
    },
  ];

  private protocols: AdminProtocol[] = [
    { id: 'proto-companion', name: 'TV Companion Protocol', code: 'companion_v1', defaultPort: 8888, transportType: 'COMPANION_APP', pairingRequired: true },
    { id: 'proto-tizen', name: 'Samsung Tizen WS', code: 'tizen_ws', defaultPort: 8001, transportType: 'DIRECT_NETWORK', pairingRequired: true },
    { id: 'proto-webos', name: 'LG webOS SSAP', code: 'webos_ssap', defaultPort: 3000, transportType: 'DIRECT_NETWORK', pairingRequired: true },
    { id: 'proto-roku', name: 'Roku ECP', code: 'roku_ecp', defaultPort: 8060, transportType: 'DIRECT_NETWORK', pairingRequired: false },
  ];

  getBrands(): AdminBrand[] {
    return this.brands;
  }

  addBrand(name: string, status: DeviceStatus = DeviceStatus.TESTING): AdminBrand {
    const brand: AdminBrand = {
      id: `brand-${Date.now()}`,
      name,
      status,
      createdAt: new Date().toISOString().substring(0, 10),
    };
    this.brands.push(brand);
    return brand;
  }

  getModels(): AdminModel[] {
    return this.models;
  }

  addModel(model: AdminModel): void {
    this.models.push(model);
  }

  getProtocols(): AdminProtocol[] {
    return this.protocols;
  }
}
