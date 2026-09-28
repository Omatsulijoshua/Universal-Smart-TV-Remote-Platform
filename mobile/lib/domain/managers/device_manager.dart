import 'package:shared/shared.dart';

class DeviceManager {
  final List<DiscoveredDevice> _savedDevices = [];

  List<DiscoveredDevice> get savedDevices => List.unmodifiable(_savedDevices);

  void addDevice(DiscoveredDevice device) {
    _savedDevices.removeWhere((d) => d.deviceId == device.deviceId);
    _savedDevices.add(device);
  }

  void removeDevice(String deviceId) {
    _savedDevices.removeWhere((d) => d.deviceId == deviceId);
  }

  DiscoveredDevice? getDeviceById(String deviceId) {
    try {
      return _savedDevices.firstWhere((d) => d.deviceId == deviceId);
    } catch (_) {
      return null;
    }
  }
}
