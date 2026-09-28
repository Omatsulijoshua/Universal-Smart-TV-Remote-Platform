import { DeviceStatus } from '@smart-tv-remote/shared';

export interface AdminBrand {
  id: string;
  name: string;
  logo?: string;
  status: DeviceStatus;
}

export interface AdminModel {
  id: string;
  brandId: string;
  model: string;
  platform: string;
  protocol: string;
  capabilities: Record<string, boolean>;
  companionRequired: boolean;
  status: DeviceStatus;
}

export interface AdminDashboardSections {
  overview: boolean;
  users: boolean;
  tvBrands: boolean;
  tvModels: boolean;
  protocols: boolean;
  capabilities: boolean;
  devices: boolean;
  pairings: boolean;
  diagnostics: boolean;
  appConfiguration: boolean;
  subscriptions: boolean;
  logs: boolean;
}

export class AdminManagementService {
  private brands: AdminBrand[] = [
    {
      id: 'brand-hikers',
      name: 'Hikers',
      status: DeviceStatus.TESTING,
    },
    {
      id: 'brand-android-tv',
      name: 'Generic Android TV',
      status: DeviceStatus.SUPPORTED,
    }
  ];

  getBrands(): AdminBrand[] {
    return this.brands;
  }

  addBrand(brand: AdminBrand): void {
    this.brands.push(brand);
  }
}
