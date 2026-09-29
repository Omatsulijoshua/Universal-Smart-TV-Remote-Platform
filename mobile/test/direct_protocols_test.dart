import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';
import 'package:mobile/domain/protocols/adapters/samsung_tizen_protocol.dart';
import 'package:mobile/domain/protocols/adapters/lg_webos_protocol.dart';
import 'package:mobile/domain/protocols/adapters/sony_bravia_protocol.dart';
import 'package:mobile/domain/protocols/adapters/roku_ecp_protocol.dart';

void main() {
  group('Phase 8 Direct Protocol Adapters Unit Test Suite', () {
    test('SamsungTizenProtocol connects and executes mapped keys', () async {
      final tizen = SamsungTizenProtocol();
      await tizen.connect('192.168.1.110');

      expect(await tizen.isConnected(), isTrue);

      final res = await tizen.sendCommand(RemoteCommand.VOLUME_UP);
      expect(res.success, isTrue);
      expect(res.command, equals(RemoteCommand.VOLUME_UP));

      final caps = await tizen.getCapabilities();
      expect(caps.volume, isTrue);
      expect(caps.companionRequired, isFalse);
    });

    test('LgWebOsProtocol connects and executes SSAP requests', () async {
      final webos = LgWebOsProtocol();
      await webos.connect('192.168.1.111');

      expect(await webos.isConnected(), isTrue);

      final res = await webos.sendCommand(RemoteCommand.HOME);
      expect(res.success, isTrue);
    });

    test('SonyBraviaProtocol connects and executes IRCC commands', () async {
      final bravia = SonyBraviaProtocol();
      await bravia.connect('192.168.1.112');

      expect(await bravia.isConnected(), isTrue);

      final res = await bravia.sendCommand(RemoteCommand.POWER_TOGGLE);
      expect(res.success, isTrue);
    });

    test('RokuEcpProtocol connects and executes ECP HTTP requests', () async {
      final roku = RokuEcpProtocol();
      await roku.connect('192.168.1.113');

      expect(await roku.isConnected(), isTrue);

      final res = await roku.sendCommand(RemoteCommand.OK);
      expect(res.success, isTrue);
    });
  });
}
