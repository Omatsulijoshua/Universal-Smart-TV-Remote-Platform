import 'package:shared/shared.dart';

abstract class CommandExecutor {
  Future<CommandExecutionResult> executeNavigation(RemoteCommand command);
  Future<CommandExecutionResult> executeVolume(RemoteCommand command);
  Future<CommandExecutionResult> executePower(RemoteCommand command);
  Future<CommandExecutionResult> executeMedia(RemoteCommand command);
  Future<CommandExecutionResult> executeTextInput(String text);
  Future<CommandExecutionResult> executeChannel(RemoteCommand command);
  Future<CommandExecutionResult> executeSource(RemoteCommand command);
}

class AndroidTvCommandExecutor implements CommandExecutor {
  @override
  Future<CommandExecutionResult> executeNavigation(RemoteCommand command) async {
    return CommandExecutionResult(success: true, command: command);
  }

  @override
  Future<CommandExecutionResult> executeVolume(RemoteCommand command) async {
    return CommandExecutionResult(success: true, command: command);
  }

  @override
  Future<CommandExecutionResult> executePower(RemoteCommand command) async {
    if (command == RemoteCommand.POWER_ON) {
      return CommandExecutionResult(
        success: false,
        command: command,
        reason: 'UNSUPPORTED: Wake-on-LAN power on is not supported by current TV hardware state.',
      );
    }
    return CommandExecutionResult(success: true, command: command);
  }

  @override
  Future<CommandExecutionResult> executeMedia(RemoteCommand command) async {
    return CommandExecutionResult(success: true, command: command);
  }

  @override
  Future<CommandExecutionResult> executeTextInput(String text) async {
    return CommandExecutionResult(success: true, command: RemoteCommand.TEXT_INPUT);
  }

  @override
  Future<CommandExecutionResult> executeChannel(RemoteCommand command) async {
    return CommandExecutionResult(success: true, command: command);
  }

  @override
  Future<CommandExecutionResult> executeSource(RemoteCommand command) async {
    return CommandExecutionResult(success: true, command: command);
  }
}
