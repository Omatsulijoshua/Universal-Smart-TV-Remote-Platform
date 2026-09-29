import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';
import 'package:mobile/domain/protocols/adapters/hikers_adapter.dart';
import 'package:mobile/domain/protocols/tv_protocol.dart';
import 'package:mobile/domain/managers/connection_manager.dart';

void main() {
  group('Phase 7 Hikers TV Compatibility Suite', () {
    test('HikersAdapter returns unknown status without inventing fake APIs', () async {
      final adapter = HikersAdapter();
      final result = await adapter.detectDirectCapabilities('192.168.1.120');

      expect(result.status, equals(DirectProtocolDetectionStatus.unknown));
      expect(result.requiresCompanionApp, isTrue);
      expect(result.message, contains('unverified'));
    });

    test('ConnectionManager resolves CompanionProtocol for Hikers TV', () async {
      final manager = ConnectionManager();
      const hikersDevice = DiscoveredDevice(
        deviceId: 'tv-hikers-test',
        name: 'Hikers Living Room TV',
        manufacturer: 'Hikers',
        model: 'Android TV 11',
        ipAddress: '192.168.1.120',
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

      final protocol = await manager.resolveBestTransport(hikersDevice);
      expect(protocol.transportType, equals(TransportType.COMPANION_APP));
    });
  });
}
