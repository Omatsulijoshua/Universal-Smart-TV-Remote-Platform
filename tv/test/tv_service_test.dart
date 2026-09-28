import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';
import 'package:tv/service/companion_service.dart';

void main() {
  group('TV Companion Service Tests', () {
    late TvCompanionService service;

    setUp(() {
      service = TvCompanionService();
    });

    test('Pairing code generation and verification', () {
      service.startAdvertising();
      expect(service.isAdvertising, isTrue);
      expect(service.currentPairingCode, isNotNull);

      final code = service.currentPairingCode!;
      expect(service.verifyPairingCode('000 000'), isFalse);
      expect(service.verifyPairingCode(code), isTrue);
      expect(service.isConnected, isTrue);
    });

    test('Unauthorized command execution rejected', () async {
      final result = await service.handleIncomingCommand(RemoteCommand.VOLUME_UP);
      expect(result.success, isFalse);
      expect(result.reason, contains('UNAUTHORIZED'));
    });

    test('Authorized command execution success', () async {
      service.startAdvertising();
      service.verifyPairingCode(service.currentPairingCode!);

      final result = await service.handleIncomingCommand(RemoteCommand.OK);
      expect(result.success, isTrue);
    });
  });
}
