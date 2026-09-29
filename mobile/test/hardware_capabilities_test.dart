import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';
import 'package:mobile/data/datasources/hardware_capabilities_datasource.dart';
import 'package:mobile/data/datasources/ir_code_database.dart';
import 'package:mobile/domain/protocols/adapters/ir_protocol.dart';
import 'package:mobile/domain/protocols/adapters/bluetooth_protocol.dart';

void main() {
  group('Phase 9 Hardware Capabilities Unit Test Suite', () {
    test('HardwareCapabilitiesDatasource platform detection', () async {
      final caps = await HardwareCapabilitiesDatasource.detectHardware();
      expect(caps, isNotNull);
    });

    test('IrCodeDatabase signal lookup', () {
      final hikersPower = IrCodeDatabase.lookupSignal('Hikers', RemoteCommand.POWER_TOGGLE);
      expect(hikersPower, isNotNull);
      expect(hikersPower!.protocol, equals('NEC'));
      expect(hikersPower.frequency, equals(38000));
      expect(hikersPower.pattern, isNotEmpty);
    });

    test('IrProtocol handles text input rejection cleanly', () async {
      final ir = IrProtocol();
      final res = await ir.sendText('Hello TV');

      expect(res.success, isFalse);
      expect(res.reason, contains('IR_TEXT_INPUT_UNSUPPORTED'));
    });

    test('BluetoothProtocol user-facing limitation error message', () async {
      final bt = BluetoothProtocol();
      final res = await bt.sendCommand(RemoteCommand.VOLUME_UP);

      expect(res.success, isFalse);
      expect(res.reason, contains('Bluetooth control isn\'t supported by this TV'));
    });
  });
}
