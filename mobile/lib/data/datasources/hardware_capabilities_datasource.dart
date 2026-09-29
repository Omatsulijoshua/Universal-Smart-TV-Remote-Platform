import 'dart:io';

class HardwareCapabilities {
  final bool hasIrBlaster;
  final bool hasBluetoothHid;
  final bool isAndroid;
  final bool isIos;

  const HardwareCapabilities({
    required this.hasIrBlaster,
    required this.hasBluetoothHid,
    required this.isAndroid,
    required this.isIos,
  });
}

class HardwareCapabilitiesDatasource {
  static Future<HardwareCapabilities> detectHardware() async {
    final isAndroidPlatform = Platform.isAndroid;
    final isIosPlatform = Platform.isIOS;

    // iOS devices do NOT possess built-in Consumer IR blasters per Section 29
    final irBlasterAvailable = isAndroidPlatform ? true : false;
    final bluetoothAvailable = true; // Supported on both Android and iOS

    return HardwareCapabilities(
      hasIrBlaster: irBlasterAvailable,
      hasBluetoothHid: bluetoothAvailable,
      isAndroid: isAndroidPlatform,
      isIos: isIosPlatform,
    );
  }
}
