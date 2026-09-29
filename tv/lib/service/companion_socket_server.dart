import 'dart:io';
import 'dart:convert';
import 'package:shared/shared.dart';
import 'companion_service.dart';

class CompanionSocketServer {
  final TvCompanionService companionService;
  ServerSocket? _serverSocket;
  bool _isListening = false;
  int port = 8888;

  CompanionSocketServer({required this.companionService});

  bool get isListening => _isListening;

  Future<bool> startServer({int targetPort = 8888}) async {
    port = targetPort;
    try {
      _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
      _isListening = true;

      _serverSocket!.listen((Socket clientSocket) {
        _handleClientConnection(clientSocket);
      });

      return true;
    } catch (_) {
      _isListening = false;
      return false;
    }
  }

  void _handleClientConnection(Socket clientSocket) {
    clientSocket.cast<List<int>>().transform(utf8.decoder).listen(
      (data) async {
        try {
          final Map<String, dynamic> jsonMap = jsonDecode(data.trim());
          final type = jsonMap['type'];

          if (type == 'DISCOVERY_INFO') {
            final info = {
              'deviceId': 'tv-hikers-companion-01',
              'name': 'Hikers Smart TV',
              'manufacturer': 'Hikers',
              'model': 'Android TV',
              'ipAddress': clientSocket.address.address,
              'port': port,
              'protocol': 'companion_v1',
              'capabilities': companionService.getCapabilities().toJson(),
              'pairingRequired': true,
              'companionRequired': true,
              'transportType': 'COMPANION_APP',
              'appVersion': '1.0.0',
              'protocolVersion': '1.0',
            };
            clientSocket.write('${jsonEncode(info)}\n');
            return;
          }

          if (type == 'PAIRING_REQUEST') {
            final code = jsonMap['pairingCode'] ?? '';
            final phoneName = jsonMap['phoneName'] ?? "Phone";

            final verified = companionService.verifyPairingCode(
              code,
              phoneName: phoneName,
              ip: clientSocket.remoteAddress.address,
            );

            if (verified) {
              final response = {
                'success': true,
                'sessionToken': 'session-${DateTime.now().millisecondsSinceEpoch}',
              };
              clientSocket.write('${jsonEncode(response)}\n');
            } else {
              final response = {
                'success': false,
                'error': 'Invalid or expired pairing code.',
              };
              clientSocket.write('${jsonEncode(response)}\n');
            }
            return;
          }

          if (type == 'EXECUTE_COMMAND') {
            final cmdName = jsonMap['command'];
            final text = jsonMap['text'];
            
            final command = RemoteCommand.values.firstWhere(
              (e) => e.name == cmdName,
              orElse: () => RemoteCommand.OK,
            );

            final result = await companionService.handleIncomingCommand(command, text: text);

            final response = {
              'success': result.success,
              'command': result.command.name,
              'reason': result.reason,
            };
            clientSocket.write('${jsonEncode(response)}\n');
            return;
          }
        } catch (_) {}
      },
      onError: (err) {
        clientSocket.destroy();
      },
      onDone: () {
        clientSocket.destroy();
      },
    );
  }

  Future<void> stopServer() async {
    _isListening = false;
    await _serverSocket?.close();
    _serverSocket = null;
  }
}
