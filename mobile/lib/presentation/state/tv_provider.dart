import 'package:flutter/foundation.dart';
import 'package:shared/shared.dart';
import '../../domain/managers/connection_manager.dart';
import '../../domain/managers/device_manager.dart';
import '../../domain/managers/remote_controller.dart';

class TvProvider extends ChangeNotifier {
  final ConnectionManager connectionManager = ConnectionManager();
  final DeviceManager deviceManager = DeviceManager();
  late final RemoteController remoteController;

  bool _isOnboardingCompleted = false;
  bool _hapticsEnabled = true;
  bool _soundEnabled = false;
  int _lastVolumeLevel = 37;

  List<DiscoveredDevice> _discoveredDevices = [];
  bool _isSearching = false;
  String? _lastCommandLog;
  int? _lastLatencyMs;

  TvProvider() {
    remoteController = RemoteController(connectionManager: connectionManager);
    _seedDefaultDevices();
  }

  bool get isOnboardingCompleted => _isOnboardingCompleted;
  bool get hapticsEnabled => _hapticsEnabled;
  bool get soundEnabled => _soundEnabled;
  int get lastVolumeLevel => _lastVolumeLevel;
  List<DiscoveredDevice> get savedDevices => deviceManager.savedDevices;
  List<DiscoveredDevice> get discoveredDevices => _discoveredDevices;
  bool get isSearching => _isSearching;
  DiscoveredDevice? get connectedDevice => connectionManager.connectedDevice;
  ConnectionStateStatus get connectionStatus => connectionManager.status;
  String? get lastCommandLog => _lastCommandLog;
  int? get lastLatencyMs => _lastLatencyMs;

  void completeOnboarding() {
    _isOnboardingCompleted = true;
    notifyListeners();
  }

  void toggleHaptics(bool value) {
    _hapticsEnabled = value;
    notifyListeners();
  }

  void toggleSound(bool value) {
    _soundEnabled = value;
    notifyListeners();
  }

  void _seedDefaultDevices() {
    // Initial sample record per section 55
    const sampleHikersTv = DiscoveredDevice(
      deviceId: 'tv-hikers-livingroom',
      name: 'Hikers TV',
      manufacturer: 'Hikers',
      model: 'Android Smart TV',
      ipAddress: '192.168.1.120',
      port: 8888,
      protocol: 'companion_v1',
      capabilities: DeviceCapabilities(
        power: true,
        powerOn: false,
        powerOff: true,
        powerToggle: true,
        wakeOverNetwork: false,
        volume: true,
        volumeQuery: true,
        mute: true,
        channels: true,
        navigation: true,
        source: true,
        sourceListQuery: true,
        media: true,
        keyboard: true,
        voice: false,
        companionRequired: true,
      ),
      pairingRequired: true,
      companionRequired: true,
      transportType: TransportType.COMPANION_APP,
    );

    deviceManager.addDevice(sampleHikersTv);
  }

  Future<void> startDiscovery() async {
    _isSearching = true;
    _discoveredDevices = [];
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    _discoveredDevices = [
      const DiscoveredDevice(
        deviceId: 'tv-hikers-livingroom',
        name: 'Hikers TV',
        manufacturer: 'Hikers',
        model: 'Living Room TV',
        ipAddress: '192.168.1.120',
        port: 8888,
        protocol: 'companion_v1',
        capabilities: DeviceCapabilities(
          power: true,
          powerOn: false,
          powerOff: true,
          powerToggle: true,
          wakeOverNetwork: false,
          volume: true,
          volumeQuery: true,
          mute: true,
          channels: true,
          navigation: true,
          source: true,
          sourceListQuery: true,
          media: true,
          keyboard: true,
          voice: false,
          companionRequired: true,
        ),
        pairingRequired: true,
        companionRequired: true,
        transportType: TransportType.COMPANION_APP,
      ),
      const DiscoveredDevice(
        deviceId: 'tv-hikers-bedroom',
        name: 'Hikers TV',
        manufacturer: 'Hikers',
        model: 'Bedroom TV',
        ipAddress: '192.168.1.125',
        port: 8888,
        protocol: 'companion_v1',
        capabilities: DeviceCapabilities(
          power: true,
          powerOn: false,
          powerOff: true,
          powerToggle: true,
          wakeOverNetwork: false,
          volume: true,
          volumeQuery: false,
          mute: true,
          channels: true,
          navigation: true,
          source: true,
          sourceListQuery: false,
          media: true,
          keyboard: true,
          voice: false,
          companionRequired: true,
        ),
        pairingRequired: true,
        companionRequired: true,
        transportType: TransportType.COMPANION_APP,
      ),
      const DiscoveredDevice(
        deviceId: 'tv-generic-192-168-1-150',
        name: 'Unknown Smart TV',
        manufacturer: 'Generic',
        model: 'Android TV',
        ipAddress: '192.168.1.150',
        port: 8888,
        protocol: 'companion_v1',
        capabilities: DeviceCapabilities(
          power: true,
          powerOn: false,
          powerOff: true,
          powerToggle: true,
          wakeOverNetwork: false,
          volume: true,
          volumeQuery: false,
          mute: true,
          channels: false,
          navigation: true,
          source: false,
          sourceListQuery: false,
          media: true,
          keyboard: true,
          voice: false,
          companionRequired: true,
        ),
        pairingRequired: true,
        companionRequired: true,
        transportType: TransportType.COMPANION_APP,
      )
    ];

    _isSearching = false;
    notifyListeners();
  }

  Future<bool> connectDevice(DiscoveredDevice device, {String? sessionToken}) async {
    final success = await connectionManager.connect(device, sessionToken: sessionToken);
    if (success) {
      deviceManager.addDevice(device);
    }
    notifyListeners();
    return success;
  }

  Future<void> disconnect() async {
    await connectionManager.disconnect();
    notifyListeners();
  }

  void forgetDevice(String deviceId) {
    if (connectedDevice?.deviceId == deviceId) {
      disconnect();
    }
    deviceManager.removeDevice(deviceId);
    notifyListeners();
  }

  Future<CommandExecutionResult> sendCommand(RemoteCommand command, {String? text}) async {
    final stopwatch = Stopwatch()..start();
    final result = await remoteController.sendCommand(command, text: text);
    stopwatch.stop();

    _lastLatencyMs = stopwatch.elapsedMilliseconds;
    _lastCommandLog = 'Command: ${command.name} | Success: ${result.success} | Latency: ${_lastLatencyMs}ms';

    if (command == RemoteCommand.VOLUME_UP && _lastVolumeLevel < 100) {
      _lastVolumeLevel++;
    } else if (command == RemoteCommand.VOLUME_DOWN && _lastVolumeLevel > 0) {
      _lastVolumeLevel--;
    }

    notifyListeners();
    return result;
  }
}
