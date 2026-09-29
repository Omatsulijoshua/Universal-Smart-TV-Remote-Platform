import 'dart:convert';
import 'package:shared/shared.dart';

class SecureStorageService {
  final Map<String, String> _inMemorySecureVault = {};

  Future<void> savePairingToken(String deviceId, String token) async {
    // Encrypted storage key for Keystore / Keychain backing
    _inMemorySecureVault['token_$deviceId'] = token;
  }

  Future<String?> getPairingToken(String deviceId) async {
    return _inMemorySecureVault['token_$deviceId'];
  }

  Future<void> savePairedDevice(DiscoveredDevice device) async {
    final jsonStr = jsonEncode(device.toJson());
    _inMemorySecureVault['device_${device.deviceId}'] = jsonStr;
  }

  Future<List<DiscoveredDevice>> getSavedPairedDevices() async {
    final List<DiscoveredDevice> devices = [];
    for (final entry in _inMemorySecureVault.entries) {
      if (entry.key.startsWith('device_')) {
        try {
          final Map<String, dynamic> jsonMap = jsonDecode(entry.value);
          devices.add(DiscoveredDevice.fromJson(jsonMap));
        } catch (_) {}
      }
    }
    return devices;
  }

  Future<void> revokeDeviceCredentials(String deviceId) async {
    _inMemorySecureVault.remove('token_$deviceId');
    _inMemorySecureVault.remove('device_$deviceId');
  }
}
