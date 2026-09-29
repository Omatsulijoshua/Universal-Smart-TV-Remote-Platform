import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';
import 'package:mobile/core/security/secure_storage_service.dart';
import 'package:mobile/data/datasources/network_discovery_datasource.dart';
import 'package:mobile/data/datasources/companion_socket_client.dart';

void main() {
  group('Phase 4 Security & Network Discovery Unit Tests', () {
    test('SecureStorageService encrypts and stores tokens', () async {
      final secureStorage = SecureStorageService();
      await secureStorage.savePairingToken('192.168.1.100', 'session-xyz-123');

      final token = await secureStorage.getPairingToken('192.168.1.100');
      expect(token, equals('session-xyz-123'));
    });

    test('NetworkDiscoveryDatasource returns discovered LAN devices', () async {
      final discovery = NetworkDiscoveryDatasource();
      final devices = await discovery.discoverLocalDevices(timeout: const Duration(milliseconds: 200));

      expect(devices, isNotEmpty);
      expect(devices.first.ipAddress, isNotEmpty);
      expect(devices.first.port, equals(8888));
    });

    test('CompanionSocketClient disconnect status', () async {
      final client = CompanionSocketClient();
      expect(client.isConnected, isFalse);

      final result = await client.sendCommand(RemoteCommand.VOLUME_UP);
      expect(result.success, isFalse);
      expect(result.reason, equals('SOCKET_DISCONNECTED'));
    });
  });
}
