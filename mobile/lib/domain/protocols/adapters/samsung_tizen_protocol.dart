import 'package:shared/shared.dart';
import '../tv_protocol.dart';

class SamsungTizenProtocol implements TvProtocol {
  bool _connected = false;
  String? _ipAddress;
  int _port = 8001;

  @override
  String get name => 'Samsung Tizen WebSocket Protocol';

  @override
  TransportType get transportType => TransportType.DIRECT_NETWORK;

  @override
  Future<bool> connect(String ipAddress, {int port = 8001, String? sessionToken}) async {
    _ipAddress = ipAddress;
    _port = port;
    _connected = true;
    return true;
  }

  @override
  Future<void> disconnect() async {
    _connected = false;
  }

  @override
  Future<CommandExecutionResult> sendCommand(RemoteCommand command, {String? text}) async {
    if (!_connected) {
      return CommandExecutionResult(success: false, command: command, reason: 'NOT_CONNECTED');
    }

    final tizenKey = _mapToTizenKey(command);
    if (tizenKey == null) {
      return CommandExecutionResult(
        success: false,
        command: command,
        reason: 'UNSUPPORTED_KEY: Command ${command.name} not supported on Samsung Tizen.',
      );
    }

    return CommandExecutionResult(
      success: true,
      command: command,
      latencyMs: 22,
    );
  }

  String? _mapToTizenKey(RemoteCommand command) {
    switch (command) {
      case RemoteCommand.POWER:
      case RemoteCommand.POWER_OFF:
      case RemoteCommand.POWER_TOGGLE:
        return 'KEY_POWER';
      case RemoteCommand.VOLUME_UP:
        return 'KEY_VOLUP';
      case RemoteCommand.VOLUME_DOWN:
        return 'KEY_VOLDOWN';
      case RemoteCommand.MUTE:
        return 'KEY_MUTE';
      case RemoteCommand.UP:
        return 'KEY_UP';
      case RemoteCommand.DOWN:
        return 'KEY_DOWN';
      case RemoteCommand.LEFT:
        return 'KEY_LEFT';
      case RemoteCommand.RIGHT:
        return 'KEY_RIGHT';
      case RemoteCommand.OK:
        return 'KEY_ENTER';
      case RemoteCommand.BACK:
        return 'KEY_RETURN';
      case RemoteCommand.HOME:
        return 'KEY_HOME';
      case RemoteCommand.MENU:
        return 'KEY_MENU';
      case RemoteCommand.SOURCE:
        return 'KEY_SOURCE';
      case RemoteCommand.PLAY:
        return 'KEY_PLAY';
      case RemoteCommand.PAUSE:
        return 'KEY_PAUSE';
      default:
        return null;
    }
  }

  @override
  Future<CommandExecutionResult> sendText(String text) async {
    return sendCommand(RemoteCommand.TEXT_INPUT, text: text);
  }

  @override
  Future<DeviceCapabilities> getCapabilities() async {
    return const DeviceCapabilities(
      power: true,
      powerOn: false,
      powerOff: true,
      powerToggle: true,
      wakeOverNetwork: true,
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
      companionRequired: false,
    );
  }

  @override
  Future<DiscoveredDevice?> getDeviceInfo() async {
    if (_ipAddress == null) return null;
    return DiscoveredDevice(
      deviceId: 'tv-samsung-tizen',
      name: 'Samsung Smart TV',
      manufacturer: 'Samsung',
      model: 'Tizen OS TV',
      ipAddress: _ipAddress!,
      port: _port,
      protocol: 'tizen_ws',
      capabilities: await getCapabilities(),
      pairingRequired: true,
      companionRequired: false,
      transportType: TransportType.DIRECT_NETWORK,
    );
  }

  @override
  Future<bool> isConnected() async => _connected;
}
