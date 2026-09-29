import 'package:shared/shared.dart';
import '../tv_protocol.dart';
import '../../../data/datasources/companion_socket_client.dart';
import '../../../core/security/secure_storage_service.dart';

class CompanionProtocol implements TvProtocol {
  final CompanionSocketClient _socketClient = CompanionSocketClient();
  final SecureStorageService _secureStorage = SecureStorageService();

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

    final connected = await _socketClient.connect(ipAddress, port);
    if (connected && sessionToken != null) {
      await _secureStorage.savePairingToken(ipAddress, sessionToken);
    }
    return connected;
  }

  Future<PairingResponse> pairWithCode(String pairingCode, String phoneName) async {
    if (!_socketClient.isConnected && _ipAddress != null) {
      await _socketClient.connect(_ipAddress!, _port);
    }

    final response = await _socketClient.sendPairingRequest(pairingCode, phoneName);
    if (response.success && response.sessionToken != null && _ipAddress != null) {
      _sessionToken = response.sessionToken;
      await _secureStorage.savePairingToken(_ipAddress!, response.sessionToken!);
    }
    return response;
  }

  @override
  Future<void> disconnect() async {
    await _socketClient.disconnect();
  }

  @override
  Future<CommandExecutionResult> sendCommand(RemoteCommand command, {String? text}) async {
    if (!_socketClient.isConnected && _ipAddress != null) {
      final reconnected = await _socketClient.connect(_ipAddress!, _port);
      if (!reconnected) {
        return CommandExecutionResult(
          success: false,
          command: command,
          reason: 'CONNECTION_FAILED: Unable to reach TV companion on LAN.',
        );
      }
    }

    return await _socketClient.sendCommand(
      command,
      text: text,
      sessionToken: _sessionToken,
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
      deviceId: 'tv-companion-active',
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
  Future<bool> isConnected() async => _socketClient.isConnected;
}
