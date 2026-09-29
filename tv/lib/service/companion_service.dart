import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared/shared.dart';
import 'command_executor.dart';
import 'companion_socket_server.dart';

class PairingCodeGenerator {
  static String generateCode() {
    final random = Random();
    final first = random.nextInt(900) + 100;
    final second = random.nextInt(900) + 100;
    return '$first $second';
  }
}

class ConnectedPhoneDevice {
  final String phoneName;
  final String phoneDeviceId;
  final String ipAddress;
  final DateTime connectedAt;

  ConnectedPhoneDevice({
    required this.phoneName,
    required this.phoneDeviceId,
    required this.ipAddress,
    required this.connectedAt,
  });
}

class TvCompanionService extends ChangeNotifier {
  final CommandExecutor executor = AndroidTvCommandExecutor();
  String? currentPairingCode;
  bool _isAdvertising = false;
  bool _isConnected = false;
  ConnectedPhoneDevice? _connectedPhone;

  final List<String> _commandHistoryLogs = [];

  bool get isAdvertising => _isAdvertising;
  bool get isConnected => _isConnected;
  ConnectedPhoneDevice? get connectedPhone => _connectedPhone;
  List<String> get commandHistoryLogs => List.unmodifiable(_commandHistoryLogs);

  late final CompanionSocketServer socketServer;

  TvCompanionService() {
    socketServer = CompanionSocketServer(companionService: this);
  }

  void startAdvertising() {
    currentPairingCode = PairingCodeGenerator.generateCode();
    _isAdvertising = true;
    socketServer.startServer();
    notifyListeners();
  }

  void stopAdvertising() {
    _isAdvertising = false;
    notifyListeners();
  }

  bool verifyPairingCode(String inputCode, {String phoneName = "Joshua's Phone", String phoneId = "phone-123", String ip = "192.168.1.105"}) {
    if (currentPairingCode == null) return false;
    final normalizedInput = inputCode.replaceAll(' ', '');
    final normalizedCurrent = currentPairingCode!.replaceAll(' ', '');
    
    if (normalizedInput == normalizedCurrent) {
      _isConnected = true;
      _connectedPhone = ConnectedPhoneDevice(
        phoneName: phoneName,
        phoneDeviceId: phoneId,
        ipAddress: ip,
        connectedAt: DateTime.now(),
      );
      _logEvent('Phone paired successfully: $phoneName ($ip)');
      notifyListeners();
      return true;
    }
    return false;
  }

  void disconnectPhone() {
    if (_connectedPhone != null) {
      _logEvent('Disconnected phone: ${_connectedPhone!.phoneName}');
    }
    _isConnected = false;
    _connectedPhone = null;
    startAdvertising();
  }

  Future<CommandExecutionResult> handleIncomingCommand(RemoteCommand command, {String? text}) async {
    if (!_isConnected) {
      final res = CommandExecutionResult(
        success: false,
        command: command,
        reason: 'UNAUTHORIZED: TV is not paired with sender device.',
      );
      _logEvent('Command rejected [UNAUTHORIZED]: ${command.name}');
      return res;
    }

    CommandExecutionResult result;
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
        result = await executor.executeNavigation(command);
        break;
      case RemoteCommand.VOLUME_UP:
      case RemoteCommand.VOLUME_DOWN:
      case RemoteCommand.MUTE:
        result = await executor.executeVolume(command);
        break;
      case RemoteCommand.POWER:
      case RemoteCommand.POWER_ON:
      case RemoteCommand.POWER_OFF:
      case RemoteCommand.POWER_TOGGLE:
        result = await executor.executePower(command);
        break;
      case RemoteCommand.TEXT_INPUT:
        result = await executor.executeTextInput(text ?? '');
        break;
      default:
        result = await executor.executeNavigation(command);
        break;
    }

    _logEvent('Executed command: ${command.name} | Success: ${result.success}${result.reason != null ? ' | Reason: ${result.reason}' : ''}');
    notifyListeners();
    return result;
  }

  void _logEvent(String message) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    _commandHistoryLogs.insert(0, '[$timestamp] $message');
    if (_commandHistoryLogs.length > 50) {
      _commandHistoryLogs.removeLast();
    }
  }

  DeviceCapabilities getCapabilities() {
    return DeviceCapabilities.companionDefault();
  }
}
