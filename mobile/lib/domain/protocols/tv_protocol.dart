import 'package:shared/shared.dart';

abstract class TvProtocol {
  String get name;
  TransportType get transportType;

  Future<bool> connect(String ipAddress, {int port = 8888, String? sessionToken});
  Future<void> disconnect();
  Future<CommandExecutionResult> sendCommand(RemoteCommand command, {String? text});
  Future<CommandExecutionResult> sendText(String text);
  Future<DeviceCapabilities> getCapabilities();
  Future<DiscoveredDevice?> getDeviceInfo();
  Future<bool> isConnected();
}

enum DirectProtocolDetectionStatus {
  verified,
  unknown,
  unsupported,
}

class DetectionResult {
  final DirectProtocolDetectionStatus status;
  final String protocolName;
  final bool requiresCompanionApp;
  final DeviceCapabilities capabilities;
  final String message;

  const DetectionResult({
    required this.status,
    required this.protocolName,
    required this.requiresCompanionApp,
    required this.capabilities,
    required this.message,
  });
}
