import 'package:shared/shared.dart';
import '../tv_protocol.dart';

class SonyBraviaProtocol implements TvProtocol {
  bool _connected = false;
  String? _ipAddress;
  int _port = 80;

  @override
  String get name => 'Sony Bravia REST & IRCC Protocol';

  @override
  TransportType get transportType => TransportType.DIRECT_NETWORK;

  @override
  Future<bool> connect(String ipAddress, {int port = 80, String? sessionToken}) async {
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

    return CommandExecutionResult(
      success: true,
      command: command,
      latencyMs: 25,
    );
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
      deviceId: 'tv-sony-bravia',
      name: 'Sony Bravia 4K TV',
      manufacturer: 'Sony',
      model: 'Bravia XR',
      ipAddress: _ipAddress!,
      port: _port,
      protocol: 'bravia_ircc',
      capabilities: await getCapabilities(),
      pairingRequired: true,
      companionRequired: false,
      transportType: TransportType.DIRECT_NETWORK,
    );
  }

  @override
  Future<bool> isConnected() async => _connected;
}
