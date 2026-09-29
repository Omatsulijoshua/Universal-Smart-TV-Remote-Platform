import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:shared/shared.dart';

class CompanionSocketClient {
  Socket? _socket;
  StreamSubscription? _subscription;
  bool _isConnected = false;
  Completer<String>? _pendingResponseCompleter;

  bool get isConnected => _isConnected;

  Future<bool> connect(String ipAddress, int port) async {
    try {
      _socket = await Socket.connect(ipAddress, port, timeout: const Duration(seconds: 4));
      _isConnected = true;

      _subscription = _socket!.cast<List<int>>().transform(utf8.decoder).listen(
        (data) {
          if (_pendingResponseCompleter != null && !_pendingResponseCompleter!.isCompleted) {
            _pendingResponseCompleter!.complete(data);
          }
        },
        onError: (err) {
          disconnect();
        },
        onDone: () {
          disconnect();
        },
      );

      return true;
    } catch (_) {
      _isConnected = false;
      return false;
    }
  }

  Future<PairingResponse> sendPairingRequest(String pairingCode, String phoneName) async {
    if (!_isConnected || _socket == null) {
      return const PairingResponse(success: false, error: 'Socket not connected.');
    }

    final payload = {
      'type': 'PAIRING_REQUEST',
      'pairingCode': pairingCode,
      'phoneName': phoneName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    try {
      _pendingResponseCompleter = Completer<String>();
      _socket!.write('${jsonEncode(payload)}\n');

      final responseStr = await _pendingResponseCompleter!.future.timeout(const Duration(seconds: 3));
      final Map<String, dynamic> jsonMap = jsonDecode(responseStr);

      return PairingResponse(
        success: jsonMap['success'] ?? false,
        sessionToken: jsonMap['sessionToken'],
        error: jsonMap['error'],
      );
    } catch (e) {
      return PairingResponse(success: false, error: 'Pairing timeout or socket error: $e');
    }
  }

  Future<CommandExecutionResult> sendCommand(RemoteCommand command, {String? text, String? sessionToken}) async {
    if (!_isConnected || _socket == null) {
      return CommandExecutionResult(
        success: false,
        command: command,
        reason: 'SOCKET_DISCONNECTED',
      );
    }

    final payload = {
      'type': 'EXECUTE_COMMAND',
      'command': command.name,
      'text': text,
      'sessionToken': sessionToken,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    final stopwatch = Stopwatch()..start();
    try {
      _pendingResponseCompleter = Completer<String>();
      _socket!.write('${jsonEncode(payload)}\n');

      final responseStr = await _pendingResponseCompleter!.future.timeout(const Duration(milliseconds: 1500));
      stopwatch.stop();

      final Map<String, dynamic> jsonMap = jsonDecode(responseStr);

      return CommandExecutionResult(
        success: jsonMap['success'] ?? false,
        command: command,
        reason: jsonMap['reason'],
        latencyMs: stopwatch.elapsedMilliseconds,
      );
    } catch (e) {
      stopwatch.stop();
      return CommandExecutionResult(
        success: false,
        command: command,
        reason: 'COMMAND_TIMEOUT: $e',
        latencyMs: stopwatch.elapsedMilliseconds,
      );
    }
  }

  Future<void> disconnect() async {
    _isConnected = false;
    await _subscription?.cancel();
    _socket?.destroy();
    _socket = null;
  }
}
