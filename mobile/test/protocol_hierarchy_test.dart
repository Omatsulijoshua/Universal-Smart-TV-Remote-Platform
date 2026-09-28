import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';
import 'package:mobile/domain/managers/connection_manager.dart';
import 'package:mobile/domain/managers/remote_controller.dart';
import 'package:mobile/domain/protocols/adapters/hikers_adapter.dart';
import 'package:mobile/domain/protocols/adapters/companion_protocol.dart';
import 'package:mobile/domain/protocols/tv_protocol.dart';

void main() {
  group('Phase 1 Protocol & Core Hierarchy Tests', () {
    test('HikersAdapter returns DIRECT_PROTOCOL_UNKNOWN per rule #53', () async {
      final adapter = HikersAdapter();
      final detection = await adapter.detectDirectCapabilities('192.168.1.50');
      
      expect(detection.status, equals(DirectProtocolDetectionStatus.unknown));
      expect(detection.requiresCompanionApp, isTrue);
    });

    test('ConnectionManager resolves companion protocol for Hikers TV', () async {
      final manager = ConnectionManager();
      const hikersTv = DiscoveredDevice(
        deviceId: 'hikers-tv-01',
        name: 'Hikers TV',
        manufacturer: 'Hikers',
        model: 'Smart TV',
        ipAddress: '192.168.1.100',
        port: 8888,
        protocol: 'unknown',
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

      final resolvedProtocol = await manager.resolveBestTransport(hikersTv);
      expect(resolvedProtocol, isA<CompanionProtocol>());
    });

    test('RemoteController capability checking hides unsupported features', () async {
      final manager = ConnectionManager();
      const tvWithLimitedCaps = DiscoveredDevice(
        deviceId: 'limited-tv-01',
        name: 'Basic TV',
        manufacturer: 'Generic',
        model: 'Basic',
        ipAddress: '192.168.1.101',
        port: 8888,
        protocol: 'companion_v1',
        capabilities: DeviceCapabilities(
          power: true,
          powerOn: false,
          powerOff: true,
          powerToggle: true,
          wakeOverNetwork: false,
          volume: false, // Volume unsupported
          volumeQuery: false,
          mute: false,
          channels: false,
          navigation: true,
          source: false,
          sourceListQuery: false,
          media: false,
          keyboard: false,
          voice: false,
          companionRequired: true,
        ),
        pairingRequired: true,
        companionRequired: true,
        transportType: TransportType.COMPANION_APP,
      );

      await manager.connect(tvWithLimitedCaps);
      final controller = RemoteController(connectionManager: manager);

      expect(controller.isCapabilitySupported(RemoteCommand.UP), isTrue);
      expect(controller.isCapabilitySupported(RemoteCommand.VOLUME_UP), isFalse);
      expect(controller.isCapabilitySupported(RemoteCommand.VOICE_INPUT), isFalse);
    });
  });
}
