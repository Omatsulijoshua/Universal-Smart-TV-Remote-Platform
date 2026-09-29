import 'package:shared/shared.dart';
import 'connection_manager.dart';

class CommandRouter {
  final ConnectionManager connectionManager;

  CommandRouter({required this.connectionManager});

  Future<CommandExecutionResult> routeCommand(RemoteCommand command, {String? text}) async {
    // 1. Verify active connection
    if (connectionManager.status != ConnectionStateStatus.connected) {
      return CommandExecutionResult(
        success: false,
        command: command,
        reason: 'UNAVAILABLE: Remote is not connected to a TV.',
      );
    }

    // 2. Validate input for specific commands
    if (command == RemoteCommand.TEXT_INPUT && (text == null || text.isEmpty)) {
      return CommandExecutionResult(
        success: false,
        command: command,
        reason: 'INVALID_ARGUMENT: Text payload cannot be empty for TEXT_INPUT.',
      );
    }

    // 3. Dispatch to active protocol adapter
    return await connectionManager.sendCommand(command, text: text);
  }
}
