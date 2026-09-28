import 'package:shared/shared.dart';
import '../tv_protocol.dart';

class HikersAdapter implements TvProtocol {
  @override
  String get name => 'Hikers Direct Adapter';

  @override
  TransportType get transportType => TransportType.UNSUPPORTED;

  Future<DetectionResult> detectDirectCapabilities(String ipAddress) async {
    // Section 53 Requirement:
    // Do NOT fake Hikers network endpoints or invent protocol payloads.
    // Explicitly return unknown status so transport hierarchy falls back to TV companion app.
    return DetectionResult(
      status: DirectProtocolDetectionStatus.unknown,
      protocolName: 'Hikers Native Protocol (Unverified)',
      requiresCompanionApp: true,
      capabilities: DeviceCapabilities.unknown(),
      message: 'Direct network protocol for Hikers TV is unverified. Falling back to Companion Application.',
    );
  }

  @override
  Future<bool> connect(String ipAddress, {int port = 8888, String? sessionToken}) async {
    return false;
  }

  @override
  Future<void> disconnect() async {}

  @override
  Future<CommandExecutionResult> sendCommand(RemoteCommand command, {String? text}) async {
    return CommandExecutionResult(
      success: false,
      command: command,
      reason: 'DIRECT_PROTOCOL_UNKNOWN: Hikers direct protocol is unverified. Install companion app.',
    );
  }

  @override
  Future<CommandExecutionResult> sendText(String text) async {
    return CommandExecutionResult(
      success: false,
      command: RemoteCommand.TEXT_INPUT,
      reason: 'DIRECT_PROTOCOL_UNKNOWN',
    );
  }

  @override
  Future<DeviceCapabilities> getCapabilities() async {
    return DeviceCapabilities.unknown();
  }

  @override
  Future<DiscoveredDevice?> getDeviceInfo() async {
    return null;
  }

  @override
  Future<bool> isConnected() async => false;
}
