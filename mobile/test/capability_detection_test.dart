import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';
import 'package:mobile/domain/managers/connection_manager.dart';
import 'package:mobile/domain/managers/remote_controller.dart';
import 'package:mobile/domain/protocols/adapters/companion_protocol.dart';
import 'package:mobile/domain/protocols/adapters/bluetooth_protocol.dart';
import 'package:mobile/domain/protocols/adapters/ir_protocol.dart';

void main() {
  group('Phase 6 Capability Detection & Dynamic Adaptation Tests', () {
    test('CompanionProtocol exposes full companion capabilities', () async {
      final protocol = CompanionProtocol();
      final caps = await protocol.getCapabilities();

      expect(caps.power, isTrue);
      expect(caps.volume, isTrue);
      expect(caps.navigation, isTrue);
      expect(caps.keyboard, isTrue);
      expect(caps.companionRequired, isTrue);
    });

    test('BluetoothProtocol hides channel and source controls', () async {
      final bluetooth = BluetoothProtocol();
      final caps = await bluetooth.getCapabilities();

      expect(caps.navigation, isTrue);
      expect(caps.volume, isTrue);
      expect(caps.channels, isFalse);
      expect(caps.source, isFalse);
    });

    test('IrProtocol hides keyboard input and voice commands', () async {
      final ir = IrProtocol();
      final caps = await ir.getCapabilities();

      expect(caps.powerOn, isTrue);
      expect(caps.volume, isTrue);
      expect(caps.keyboard, isFalse);
      expect(caps.voice, isFalse);
    });

    test('Dynamic UI adaptation for limited hardware TV', () async {
      final manager = ConnectionManager();
      const basicTv = DiscoveredDevice(
        deviceId: 'tv-basic-01',
        name: 'Basic Display TV',
        manufacturer: 'Hikers',
        model: 'Display Panel',
        ipAddress: '192.168.1.180',
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
          channels: false, // Channels unsupported
          navigation: true,
          source: true,
          sourceListQuery: false,
          media: false, // Media unsupported
          keyboard: false, // Keyboard unsupported
          voice: false, // Voice unsupported
          companionRequired: true,
        ),
        pairingRequired: true,
        companionRequired: true,
        transportType: TransportType.COMPANION_APP,
      );

      await manager.connect(basicTv);
      final controller = RemoteController(connectionManager: manager);

      // Verify supported controls return true
      expect(controller.isCapabilitySupported(RemoteCommand.UP), isTrue);
      expect(controller.isCapabilitySupported(RemoteCommand.POWER), isTrue);

      // Verify unsupported controls return false for UI hiding
      expect(controller.isCapabilitySupported(RemoteCommand.VOLUME_UP), isFalse);
      expect(controller.isCapabilitySupported(RemoteCommand.CHANNEL_UP), isFalse);
      expect(controller.isCapabilitySupported(RemoteCommand.PLAY), isFalse);
      expect(controller.isCapabilitySupported(RemoteCommand.TEXT_INPUT), isFalse);
      expect(controller.isCapabilitySupported(RemoteCommand.VOICE_INPUT), isFalse);
    });
  });
}
