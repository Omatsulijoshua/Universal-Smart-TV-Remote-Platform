import 'package:shared/shared.dart';
import '../protocols/tv_protocol.dart';
import '../protocols/adapters/companion_protocol.dart';
import '../protocols/adapters/hikers_adapter.dart';
import '../protocols/adapters/bluetooth_protocol.dart';
import '../protocols/adapters/ir_protocol.dart';

enum ConnectionStateStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  unavailable,
}

class ConnectionManager {
  TvProtocol? _activeProtocol;
  DiscoveredDevice? _connectedDevice;
  ConnectionStateStatus _status = ConnectionStateStatus.disconnected;

  ConnectionStateStatus get status => _status;
  DiscoveredDevice? get connectedDevice => _connectedDevice;
  TvProtocol? get activeProtocol => _activeProtocol;

  /// Transport hierarchy decision engine per Section 2 CORE PRODUCT PRINCIPLE:
  /// 1. Existing supported TV network protocol
  /// 2. TV companion application
  /// 3. Bluetooth/HID where supported
  /// 4. IR blaster where phone has IR hardware
  /// 5. Unsupported-device explanation
  Future<TvProtocol> resolveBestTransport(DiscoveredDevice device, {bool hasIrHardware = false}) async {
    // Check direct manufacturer protocol verification (e.g. Hikers)
    if (device.manufacturer.toLowerCase().contains('hikers')) {
      final hikersAdapter = HikersAdapter();
      final detection = await hikersAdapter.detectDirectCapabilities(device.ipAddress);
      if (detection.status == DirectProtocolDetectionStatus.verified) {
        return hikersAdapter;
      }
    }

    // Fallback to companion app if required/advertised
    if (device.companionRequired || device.transportType == TransportType.COMPANION_APP) {
      return CompanionProtocol();
    }

    // Bluetooth check
    if (device.transportType == TransportType.BLUETOOTH) {
      return BluetoothProtocol();
    }

    // IR Blaster fallback if phone hardware present
    if (hasIrHardware) {
      return IrProtocol();
    }

    // Default to companion protocol fallback
    return CompanionProtocol();
  }

  Future<bool> connect(DiscoveredDevice device, {String? sessionToken}) async {
    _status = ConnectionStateStatus.connecting;
    _activeProtocol = await resolveBestTransport(device);
    final success = await _activeProtocol!.connect(device.ipAddress, port: device.port, sessionToken: sessionToken);
    
    if (success) {
      _status = ConnectionStateStatus.connected;
      _connectedDevice = device;
      return true;
    } else {
      _status = ConnectionStateStatus.unavailable;
      return false;
    }
  }

  Future<void> disconnect() async {
    if (_activeProtocol != null) {
      await _activeProtocol!.disconnect();
    }
    _status = ConnectionStateStatus.disconnected;
    _connectedDevice = null;
  }

  Future<CommandExecutionResult> sendCommand(RemoteCommand command, {String? text}) async {
    if (_status != ConnectionStateStatus.connected || _activeProtocol == null) {
      return CommandExecutionResult(
        success: false,
        command: command,
        reason: 'UNAVAILABLE: Remote is not connected to a TV.',
      );
    }
    return await _activeProtocol!.sendCommand(command, text: text);
  }
}
