import 'dart:math';
import 'package:shared/shared.dart';
import 'command_executor.dart';

class PairingCodeGenerator {
  static String generateCode() {
    final random = Random();
    final first = random.nextInt(900) + 100;
    final second = random.nextInt(900) + 100;
    return '$first $second';
  }
}

class TvCompanionService {
  final CommandExecutor executor = AndroidTvCommandExecutor();
  String? currentPairingCode;
  bool _isAdvertising = false;
  bool _isConnected = false;

  bool get isAdvertising => _isAdvertising;
  bool get isConnected => _isConnected;

  void startAdvertising() {
    currentPairingCode = PairingCodeGenerator.generateCode();
    _isAdvertising = true;
  }

  void stopAdvertising() {
    _isAdvertising = false;
  }

  bool verifyPairingCode(String inputCode) {
    if (currentPairingCode == null) return false;
    final normalizedInput = inputCode.replaceAll(' ', '');
    final normalizedCurrent = currentPairingCode!.replaceAll(' ', '');
    if (normalizedInput == normalizedCurrent) {
      _isConnected = true;
      return true;
    }
    return false;
  }

  Future<CommandExecutionResult> handleIncomingCommand(RemoteCommand command, {String? text}) async {
    if (!_isConnected) {
      return CommandExecutionResult(
        success: false,
        command: command,
        reason: 'UNAUTHORIZED: TV is not paired with sender device.',
      );
    }

    switch (command) {
      case RemoteCommand.UP:
      case RemoteCommand.DOWN:
      case RemoteCommand.LEFT:
      case RemoteCommand.RIGHT:
      case RemoteCommand.OK:
      case RemoteCommand.BACK:
      case RemoteCommand.HOME:
      case RemoteCommand.MENU:
      case RemoteCommand.GUIDE:
        return await executor.executeNavigation(command);
      case RemoteCommand.VOLUME_UP:
      case RemoteCommand.VOLUME_DOWN:
      case RemoteCommand.MUTE:
        return await executor.executeVolume(command);
      case RemoteCommand.POWER:
      case RemoteCommand.POWER_ON:
      case RemoteCommand.POWER_OFF:
      case RemoteCommand.POWER_TOGGLE:
        return await executor.executePower(command);
      case RemoteCommand.TEXT_INPUT:
        return await executor.executeTextInput(text ?? '');
      default:
        return await executor.executeNavigation(command);
    }
  }

  DeviceCapabilities getCapabilities() {
    return DeviceCapabilities.companionDefault();
  }
}
