import 'package:shared/shared.dart';
import '../tv_protocol.dart';

class BluetoothProtocol implements TvProtocol {
  bool _connected = false;

  @override
  String get name => 'Bluetooth HID Protocol';

  @override
  TransportType get transportType => TransportType.BLUETOOTH;

  @override
  Future<bool> connect(String address, {int port = 0, String? sessionToken}) async {
    _connected = false;
    return false;
  }

  @override
  Future<void> disconnect() async {
    _connected = false;
  }

  @override
  Future<CommandExecutionResult> sendCommand(RemoteCommand command, {String? text}) async {
    return CommandExecutionResult(
      success: false,
      command: command,
      reason: 'BLUETOOTH_NOT_PAIRED',
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
