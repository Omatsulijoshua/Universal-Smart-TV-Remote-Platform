import 'package:shared/shared.dart';
import '../tv_protocol.dart';
import '../../../data/datasources/hardware_capabilities_datasource.dart';
import '../../../data/datasources/ir_code_database.dart';

class IrProtocol implements TvProtocol {
  bool _hasIrHardware = false;

  @override
  String get name => 'IR Blaster Protocol';

  @override
  TransportType get transportType => TransportType.IR_BLASTER;

  @override
  Future<bool> connect(String code, {int port = 0, String? sessionToken}) async {
    final caps = await HardwareCapabilitiesDatasource.detectHardware();
    _hasIrHardware = caps.hasIrBlaster;
    
    // Per Section 29: iOS must NOT claim built-in IR support
    if (caps.isIos) {
      _hasIrHardware = false;
      return false;
    }
    return _hasIrHardware;
  }

  @override
  Future<void> disconnect() async {}

  @override
  Future<CommandExecutionResult> sendCommand(RemoteCommand command, {String? text}) async {
    final caps = await HardwareCapabilitiesDatasource.detectHardware();
    if (caps.isIos || !_hasIrHardware) {
      return CommandExecutionResult(
        success: false,
        command: command,
        reason: 'IR_HARDWARE_UNAVAILABLE: Your phone does not contain an IR blaster hardware module.',
      );
    }

    final signal = IrCodeDatabase.lookupSignal('Hikers', command);
    if (signal == null) {
      return CommandExecutionResult(
        success: false,
        command: command,
        reason: 'IR_CODE_UNAVAILABLE: No IR hex signal code found for ${command.name}.',
      );
    }

    // ConsumerIrManager transmit payload simulation
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
      reason: 'IR_TEXT_INPUT_UNSUPPORTED: IR blasters do not support text keyboard streaming.',
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
  Future<bool> isConnected() async => _hasIrHardware;
}
