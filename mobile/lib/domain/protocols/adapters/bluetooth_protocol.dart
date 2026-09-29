import 'package:shared/shared.dart';
import '../tv_protocol.dart';
import '../../../data/datasources/hardware_capabilities_datasource.dart';

class BluetoothProtocol implements TvProtocol {
  bool _connected = false;

  @override
  String get name => 'Bluetooth HID Protocol';

  @override
  TransportType get transportType => TransportType.BLUETOOTH;

  @override
  Future<bool> connect(String address, {int port = 0, String? sessionToken}) async {
    final caps = await HardwareCapabilitiesDatasource.detectHardware();
    if (!caps.hasBluetoothHid) {
      _connected = false;
      return false;
    }
    _connected = false; // Requires active HID pairing
    return false;
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
        reason: 'Bluetooth control isn\'t supported by this TV. Try connecting via the TV companion app.',
      );
    }

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
    return const DeviceCapabilities(
      power: true,
      powerOn: false,
      powerOff: true,
      powerToggle: true,
      wakeOverNetwork: false,
      volume: true,
      volumeQuery: false,
      mute: true,
      channels: false,
      navigation: true,
      source: false,
      sourceListQuery: false,
      media: true,
      keyboard: true,
      voice: false,
      companionRequired: false,
    );
  }

  @override
  Future<DiscoveredDevice?> getDeviceInfo() async => null;

  @override
  Future<bool> isConnected() async => _connected;
}
