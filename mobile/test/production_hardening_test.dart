import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';
import 'package:mobile/core/network/network_resilience_manager.dart';
import 'package:mobile/domain/managers/device_manager.dart';

void main() {
  group('Phase 12 Production Hardening & Resilience Tests', () {
    test('FriendlyErrorTranslator translates raw SocketExceptions into user guidance', () {
      const rawError = 'SocketException: OS Error: Connection refused, errno = 111, address = 192.168.1.120, port = 8888';
      final friendlyMsg = FriendlyErrorTranslator.translate(rawError);

      expect(friendlyMsg, contains('Unable to connect to your TV'));
      expect(friendlyMsg, contains('same Wi-Fi network'));
      expect(friendlyMsg, isNot(contains('SocketException')));
    });

    test('Exponential backoff reconnect produces progressive delays', () {
      final backoff = ExponentialBackoffReconnect();

      final delay1 = backoff.nextDelay();
      final delay2 = backoff.nextDelay();
      final delay3 = backoff.nextDelay();

      expect(delay1.inSeconds, equals(2));
      expect(delay2.inSeconds, equals(4));
      expect(delay3.inSeconds, equals(8));

      backoff.reset();
      expect(backoff.nextDelay().inSeconds, equals(2));
    });

    test('DeviceManager deduplicates devices with duplicate IDs', () {
      final manager = DeviceManager();

      const dev1 = DiscoveredDevice(
        deviceId: 'tv-duplicate-01',
        name: 'Hikers Living Room',
        manufacturer: 'Hikers',
        model: 'Android TV',
        ipAddress: '192.168.1.100',
        port: 8888,
        protocol: 'companion_v1',
        capabilities: DeviceCapabilities(
          power: true,
          powerOn: false,
          powerOff: true,
          powerToggle: true,
          wakeOverNetwork: false,
          volume: true,
          volumeQuery: true,
          mute: true,
          channels: true,
          navigation: true,
          source: true,
          sourceListQuery: true,
          media: true,
          keyboard: true,
          voice: false,
          companionRequired: true,
        ),
        pairingRequired: true,
        companionRequired: true,
        transportType: TransportType.COMPANION_APP,
      );

      const dev1Updated = DiscoveredDevice(
        deviceId: 'tv-duplicate-01',
        name: 'Hikers Living Room (Updated)',
        manufacturer: 'Hikers',
        model: 'Android TV v2',
        ipAddress: '192.168.1.105',
        port: 8888,
        protocol: 'companion_v1',
        capabilities: DeviceCapabilities(
          power: true,
          powerOn: false,
          powerOff: true,
          powerToggle: true,
          wakeOverNetwork: false,
          volume: true,
          volumeQuery: true,
          mute: true,
          channels: true,
          navigation: true,
          source: true,
          sourceListQuery: true,
          media: true,
          keyboard: true,
          voice: false,
          companionRequired: true,
        ),
        pairingRequired: true,
        companionRequired: true,
        transportType: TransportType.COMPANION_APP,
      );

      manager.addDevice(dev1);
      manager.addDevice(dev1Updated);

      expect(manager.savedDevices.length, equals(1));
      expect(manager.savedDevices.first.name, equals('Hikers Living Room (Updated)'));
    });
  });
}
