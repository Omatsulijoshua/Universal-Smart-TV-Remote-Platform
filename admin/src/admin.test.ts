import { AdminDashboardService, AdminModel } from './index';
import { DeviceStatus } from '@smart-tv-remote/shared';

function assert(condition: boolean, message: string) {
  if (!condition) {
    throw new Error(`Assertion Failed: ${message}`);
  }
}

function runAdminTests() {
  const service = new AdminDashboardService();

  // Test 1: Retrieve initial brand list
  const brands = service.getBrands();
  assert(brands.length >= 6, 'Should have at least 6 initial brands');
  assert(brands.some((b) => b.name === 'Hikers'), 'Hikers brand should exist');

  // Test 2: Add new brand
  const newBrand = service.addBrand('TCL Smart TV', DeviceStatus.SUPPORTED);
  assert(newBrand.id.startsWith('brand-'), 'Brand ID should have brand- prefix');
  assert(service.getBrands().includes(newBrand), 'New brand should be registered');

  // Test 3: Add new model with capabilities
  const model: AdminModel = {
    id: 'model-hikers-55',
    brandId: 'brand-hikers',
    model: 'Hikers 55" 4K Smart TV',
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
    status: DeviceStatus.SUPPORTED,
  };
  service.addModel(model);
  assert(service.getModels().includes(model), 'New model should be registered');

  // Test 4: Retrieve registered protocols
  const protocols = service.getProtocols();
  assert(protocols.length === 4, 'Should have 4 protocols registered');
  assert(protocols.some((p) => p.code === 'companion_v1'), 'Companion protocol should exist');

  console.log('All Admin Dashboard Unit Tests Passed Successfully!');
}

runAdminTests();
