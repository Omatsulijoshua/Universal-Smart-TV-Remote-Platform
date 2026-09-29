import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';
import 'package:mobile/domain/managers/connection_manager.dart';
import 'package:mobile/domain/managers/command_router.dart';

void main() {
  group('Phase 5 Automated Command Execution & Harness Tests', () {
    late ConnectionManager connectionManager;
    late CommandRouter commandRouter;

    const testTv = DiscoveredDevice(
      deviceId: 'tv-test-01',
      name: 'Hikers Test TV',
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
        voice: true,
        companionRequired: true,
      ),
      pairingRequired: true,
      companionRequired: true,
      transportType: TransportType.COMPANION_APP,
    );

    setUp(() async {
      connectionManager = ConnectionManager();
      commandRouter = CommandRouter(connectionManager: connectionManager);
      await connectionManager.connect(testTv);
    });

    test('D-Pad navigation commands (UP, DOWN, LEFT, RIGHT, OK)', () async {
      final navCommands = [
        RemoteCommand.UP,
        RemoteCommand.DOWN,
        RemoteCommand.LEFT,
        RemoteCommand.RIGHT,
        RemoteCommand.OK,
      ];

      for (final cmd in navCommands) {
        final result = await commandRouter.routeCommand(cmd);
        expect(result.command, equals(cmd));
        expect(result.success, isTrue);
      }
    });

    test('System navigation (BACK, HOME, MENU, GUIDE)', () async {
      final sysCommands = [
        RemoteCommand.BACK,
        RemoteCommand.HOME,
        RemoteCommand.MENU,
        RemoteCommand.GUIDE,
      ];

      for (final cmd in sysCommands) {
        final result = await commandRouter.routeCommand(cmd);
        expect(result.command, equals(cmd));
        expect(result.success, isTrue);
      }
    });

    test('Volume controls (VOLUME_UP, VOLUME_DOWN, MUTE)', () async {
      final volCommands = [
        RemoteCommand.VOLUME_UP,
        RemoteCommand.VOLUME_DOWN,
        RemoteCommand.MUTE,
      ];

      for (final cmd in volCommands) {
        final result = await commandRouter.routeCommand(cmd);
        expect(result.command, equals(cmd));
        expect(result.success, isTrue);
      }
    });

    test('Channel controls (CHANNEL_UP, CHANNEL_DOWN, NUMBER_0..9)', () async {
      final channelCommands = [
        RemoteCommand.CHANNEL_UP,
        RemoteCommand.CHANNEL_DOWN,
        RemoteCommand.NUMBER_0,
        RemoteCommand.NUMBER_1,
        RemoteCommand.NUMBER_2,
        RemoteCommand.NUMBER_3,
        RemoteCommand.NUMBER_4,
        RemoteCommand.NUMBER_5,
        RemoteCommand.NUMBER_6,
        RemoteCommand.NUMBER_7,
        RemoteCommand.NUMBER_8,
        RemoteCommand.NUMBER_9,
      ];

      for (final cmd in channelCommands) {
        final result = await commandRouter.routeCommand(cmd);
        expect(result.command, equals(cmd));
        expect(result.success, isTrue);
      }
    });

    test('Media playback controls (PLAY, PAUSE, STOP, REWIND, FAST_FORWARD)', () async {
      final mediaCommands = [
        RemoteCommand.PLAY,
        RemoteCommand.PAUSE,
        RemoteCommand.STOP,
        RemoteCommand.REWIND,
        RemoteCommand.FAST_FORWARD,
        RemoteCommand.PREVIOUS,
        RemoteCommand.NEXT,
      ];

      for (final cmd in mediaCommands) {
        final result = await commandRouter.routeCommand(cmd);
        expect(result.command, equals(cmd));
        expect(result.success, isTrue);
      }
    });

    test('Source input selection and Text input transmission', () async {
      final sourceResult = await commandRouter.routeCommand(RemoteCommand.SOURCE, text: 'HDMI 1');
      expect(sourceResult.success, isTrue);

      final textResult = await commandRouter.routeCommand(RemoteCommand.TEXT_INPUT, text: 'Search YouTube');
      expect(textResult.success, isTrue);
    });

    test('Empty text input fails validation', () async {
      final emptyTextResult = await commandRouter.routeCommand(RemoteCommand.TEXT_INPUT, text: '');
      expect(emptyTextResult.success, isFalse);
      expect(emptyTextResult.reason, contains('INVALID_ARGUMENT'));
    });
  });
}
