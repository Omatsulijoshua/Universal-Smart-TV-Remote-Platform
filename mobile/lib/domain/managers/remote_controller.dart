import 'package:shared/shared.dart';
import 'connection_manager.dart';

class RemoteController {
  final ConnectionManager connectionManager;

  RemoteController({required this.connectionManager});

  Future<CommandExecutionResult> sendCommand(RemoteCommand command, {String? text}) async {
    return await connectionManager.sendCommand(command, text: text);
  }

  Future<CommandExecutionResult> sendText(String text) async {
    return await connectionManager.sendCommand(RemoteCommand.TEXT_INPUT, text: text);
  }

  bool isCapabilitySupported(RemoteCommand command) {
    final device = connectionManager.connectedDevice;
    if (device == null) return false;

    final caps = device.capabilities;
    switch (command) {
      case RemoteCommand.POWER:
      case RemoteCommand.POWER_TOGGLE:
        return caps.power || caps.powerToggle;
      case RemoteCommand.POWER_ON:
        return caps.powerOn || caps.wakeOverNetwork;
      case RemoteCommand.POWER_OFF:
        return caps.powerOff;
      case RemoteCommand.VOLUME_UP:
      case RemoteCommand.VOLUME_DOWN:
        return caps.volume;
      case RemoteCommand.MUTE:
        return caps.mute;
      case RemoteCommand.CHANNEL_UP:
      case RemoteCommand.CHANNEL_DOWN:
        return caps.channels;
      case RemoteCommand.UP:
      case RemoteCommand.DOWN:
      case RemoteCommand.LEFT:
      case RemoteCommand.RIGHT:
      case RemoteCommand.OK:
      case RemoteCommand.BACK:
      case RemoteCommand.HOME:
      case RemoteCommand.MENU:
      case RemoteCommand.GUIDE:
        return caps.navigation;
      case RemoteCommand.SOURCE:
        return caps.source;
      case RemoteCommand.PLAY:
      case RemoteCommand.PAUSE:
      case RemoteCommand.STOP:
      case RemoteCommand.REWIND:
      case RemoteCommand.FAST_FORWARD:
      case RemoteCommand.PREVIOUS:
      case RemoteCommand.NEXT:
        return caps.media;
      case RemoteCommand.TEXT_INPUT:
        return caps.keyboard;
      case RemoteCommand.VOICE_INPUT:
        return caps.voice;
      default:
        return true;
    }
  }
}
