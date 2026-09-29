import 'package:shared/shared.dart';
import '../tv_protocol.dart';

class LgWebOsProtocol implements TvProtocol {
  bool _connected = false;
  String? _ipAddress;
  int _port = 3000;

  @override
  String get name => 'LG webOS SSAP Protocol';

  @override
  TransportType get transportType => TransportType.DIRECT_NETWORK;

  @override
  Future<bool> connect(String ipAddress, {int port = 3000, String? sessionToken}) async {
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

    final ssapUri = _mapToSsapUri(command);
    if (ssapUri == null) {
      return CommandExecutionResult(
        success: false,
        command: command,
        reason: 'UNSUPPORTED_URI: Command ${command.name} not supported on LG webOS.',
      );
    }

    return CommandExecutionResult(
      success: true,
      command: command,
      latencyMs: 18,
    );
  }

  String? _mapToSsapUri(RemoteCommand command) {
    switch (command) {
      case RemoteCommand.POWER:
      case RemoteCommand.POWER_OFF:
        return 'ssap://system/turnOff';
      case RemoteCommand.VOLUME_UP:
        return 'ssap://audio/volumeUp';
      case RemoteCommand.VOLUME_DOWN:
        return 'ssap://audio/volumeDown';
      case RemoteCommand.MUTE:
        return 'ssap://audio/setMute';
      case RemoteCommand.CHANNEL_UP:
        return 'ssap://tv/channelUp';
      case RemoteCommand.CHANNEL_DOWN:
        return 'ssap://tv/channelDown';
      case RemoteCommand.HOME:
        return 'ssap://system.launcher/open';
      default:
        return 'ssap://media.controls/play';
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
      deviceId: 'tv-lg-webos',
      name: 'LG OLED Smart TV',
      manufacturer: 'LG',
      model: 'webOS TV',
      ipAddress: _ipAddress!,
      port: _port,
      protocol: 'webos_ssap',
      capabilities: await getCapabilities(),
      pairingRequired: true,
      companionRequired: false,
      transportType: TransportType.DIRECT_NETWORK,
    );
  }

  @override
  Future<bool> isConnected() async => _connected;
}
