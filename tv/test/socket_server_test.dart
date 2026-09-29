import 'package:flutter_test/flutter_test.dart';
import 'package:tv/service/companion_service.dart';
import 'package:tv/service/companion_socket_server.dart';

void main() {
  group('Phase 4 TV Socket Server Tests', () {
    late TvCompanionService service;
    late CompanionSocketServer server;

    setUp(() {
      service = TvCompanionService();
      server = CompanionSocketServer(companionService: service);
    });

    tearDown(() async {
      await server.stopServer();
    });

    test('CompanionSocketServer initialization and state', () {
      expect(server.isListening, isFalse);
    });
  });
}
