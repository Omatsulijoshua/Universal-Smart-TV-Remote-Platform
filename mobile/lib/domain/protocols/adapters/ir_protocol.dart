import 'package:shared/shared.dart';
import '../tv_protocol.dart';

class IrProtocol implements TvProtocol {
  @override
  String get name => 'IR Blaster Protocol';

  @override
  TransportType get transportType => TransportType.IR_BLASTER;

  @override
  Future<bool> connect(String code, {int port = 0, String? sessionToken}) async {
    return true; // IR is stateless transmit
  }

  @override
  Future<void> disconnect() async {}

  @override
  Future<CommandExecutionResult> sendCommand(RemoteCommand command, {String? text}) async {
    return CommandExecutionResult(
      success: true,
      command: command,
      latencyMs: 5,
    );
  }

  @override
  Future<CommandExecutionResult> sendText(String text) async {
    return CommandExecutionResult(
      success: false,
      command: RemoteCommand.TEXT_INPUT,
      reason: 'IR_TEXT_INPUT_UNSUPPORTED',
    );
  }

  @override
  Future<DeviceCapabilities> getCapabilities() async {
    return const DeviceCapabilities(
      power: true,
      powerOn: true,
      powerOff: true,
      powerToggle: true,
      wakeOverNetwork: false,
      volume: true,
      volumeQuery: false,
      mute: true,
      channels: true,
      navigation: true,
      source: true,
      sourceListQuery: false,
      media: true,
      keyboard: false,
      voice: false,
      companionRequired: false,
    );
  }

  @override
  Future<DiscoveredDevice?> getDeviceInfo() async => null;

  @override
  Future<bool> isConnected() async => true;
}
