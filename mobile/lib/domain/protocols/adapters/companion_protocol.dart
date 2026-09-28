import 'package:shared/shared.dart';
import '../tv_protocol.dart';

class CompanionProtocol implements TvProtocol {
  bool _connected = false;
  String? _ipAddress;
  int _port = 8888;
  String? _sessionToken;

  String? get sessionToken => _sessionToken;

  @override
  String get name => 'Companion App Protocol';

  @override
  TransportType get transportType => TransportType.COMPANION_APP;

  @override
  Future<bool> connect(String ipAddress, {int port = 8888, String? sessionToken}) async {
    _ipAddress = ipAddress;
    _port = port;
    _sessionToken = sessionToken;
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
      return CommandExecutionResult(
        success: false,
        command: command,
        reason: 'NOT_CONNECTED',
      );
    }
    // Command execution placeholder - will transmit over socket/HTTP in phase 4/5
    return CommandExecutionResult(
      success: true,
      command: command,
      latencyMs: 15,
    );
  }

  @override
  Future<CommandExecutionResult> sendText(String text) async {
    return sendCommand(RemoteCommand.TEXT_INPUT, text: text);
  }

  @override
  Future<DeviceCapabilities> getCapabilities() async {
    return DeviceCapabilities.companionDefault();
  }

  @override
  Future<DiscoveredDevice?> getDeviceInfo() async {
    if (_ipAddress == null) return null;
    return DiscoveredDevice(
      deviceId: 'tv-companion-placeholder',
      name: 'Smart TV Companion',
      manufacturer: 'Hikers / Generic',
      model: 'Android TV',
      ipAddress: _ipAddress!,
      port: _port,
      protocol: 'companion_v1',
      capabilities: DeviceCapabilities.companionDefault(),
      pairingRequired: true,
      companionRequired: true,
      transportType: TransportType.COMPANION_APP,
    );
  }

  @override
  Future<bool> isConnected() async => _connected;
}
