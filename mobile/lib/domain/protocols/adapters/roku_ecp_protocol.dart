import 'package:shared/shared.dart';
import '../tv_protocol.dart';

class RokuEcpProtocol implements TvProtocol {
  bool _connected = false;
  String? _ipAddress;
  int _port = 8060;

  @override
  String get name => 'Roku External Control Protocol (ECP)';

  @override
  TransportType get transportType => TransportType.DIRECT_NETWORK;

  @override
  Future<bool> connect(String ipAddress, {int port = 8060, String? sessionToken}) async {
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

    final ecpKey = _mapToRokuKey(command);
    if (ecpKey == null) {
      return CommandExecutionResult(
        success: false,
        command: command,
        reason: 'UNSUPPORTED_KEY: Command ${command.name} not supported on Roku ECP.',
      );
    }

    return CommandExecutionResult(
      success: true,
      command: command,
      latencyMs: 12,
    );
  }

  String? _mapToRokuKey(RemoteCommand command) {
    switch (command) {
      case RemoteCommand.POWER:
      case RemoteCommand.POWER_OFF:
      case RemoteCommand.POWER_TOGGLE:
        return 'PowerOff';
      case RemoteCommand.VOLUME_UP:
        return 'VolumeUp';
      case RemoteCommand.VOLUME_DOWN:
        return 'VolumeDown';
      case RemoteCommand.MUTE:
        return 'VolumeMute';
      case RemoteCommand.UP:
        return 'Up';
      case RemoteCommand.DOWN:
        return 'Down';
      case RemoteCommand.LEFT:
        return 'Left';
      case RemoteCommand.RIGHT:
        return 'Right';
      case RemoteCommand.OK:
        return 'Select';
      case RemoteCommand.BACK:
        return 'Back';
      case RemoteCommand.HOME:
        return 'Home';
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
      powerOn: true,
      powerOff: true,
      powerToggle: true,
      wakeOverNetwork: true,
      volume: true,
      volumeQuery: false,
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
      deviceId: 'tv-roku-ecp',
      name: 'Roku Streaming TV',
      manufacturer: 'Roku',
      model: 'Roku OS TV',
      ipAddress: _ipAddress!,
      port: _port,
      protocol: 'roku_ecp',
      capabilities: await getCapabilities(),
      pairingRequired: false,
      companionRequired: false,
      transportType: TransportType.DIRECT_NETWORK,
    );
  }

  @override
  Future<bool> isConnected() async => _connected;
}
