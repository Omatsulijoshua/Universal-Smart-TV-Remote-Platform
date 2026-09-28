import 'package:test/test.dart';
import 'package:shared/shared.dart';

void main() {
  group('Shared Dart Protocol Tests', () {
    test('DeviceCapabilities serialization & deserialization', () {
      final defaultCaps = DeviceCapabilities.companionDefault();
      final json = defaultCaps.toJson();
      final deserialized = DeviceCapabilities.fromJson(json);

      expect(deserialized.power, equals(defaultCaps.power));
      expect(deserialized.volume, equals(defaultCaps.volume));
      expect(deserialized.companionRequired, equals(defaultCaps.companionRequired));
    });

    test('DiscoveredDevice model creation', () {
      const device = DiscoveredDevice(
        deviceId: 'tv-1',
        name: 'Hikers Living Room',
        manufacturer: 'Hikers',
        model: 'Smart Android TV',
        ipAddress: '192.168.1.50',
        port: 8888,
        protocol: 'companion_v1',
        capabilities: DeviceCapabilities(
          power: true,
          powerOn: false,
          powerOff: true,
          powerToggle: true,
          wakeOverNetwork: false,
          volume: true,
          volumeQuery: false,
          mute: true,
          channels: true,
          navigation: true,
          source: true,
          sourceListQuery: false,
          media: true,
          keyboard: true,
          voice: false,
          companionRequired: true,
        ),
        pairingRequired: true,
        companionRequired: true,
        transportType: TransportType.COMPANION_APP,
      );

      final json = device.toJson();
      final parsed = DiscoveredDevice.fromJson(json);

      expect(parsed.deviceId, equals('tv-1'));
      expect(parsed.manufacturer, equals('Hikers'));
      expect(parsed.transportType, equals(TransportType.COMPANION_APP));
    });
  });
}
