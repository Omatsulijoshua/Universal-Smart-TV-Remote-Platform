import 'package:shared/shared.dart';
import '../tv_protocol.dart';

class AndroidTvProtocol implements TvProtocol {
  bool _connected = false;

  @override
  String get name => 'Android TV Remote Protocol';

  @override
  TransportType get transportType => TransportType.DIRECT_NETWORK;

  @override
  Future<bool> connect(String ipAddress, {int port = 6466, String? sessionToken}) async {
    _connected = false; // requires pairing verification
    return _connected;
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
      reason: 'ANDROID_TV_PAIRING_REQUIRED',
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
      channels: true,
      navigation: true,
      source: true,
      sourceListQuery: false,
      media: true,
      keyboard: true,
      voice: true,
      companionRequired: false,
    );
  }

  @override
  Future<DiscoveredDevice?> getDeviceInfo() async => null;

  @override
  Future<bool> isConnected() async => _connected;
}
