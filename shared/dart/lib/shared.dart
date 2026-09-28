library shared;

enum RemoteCommand {
  POWER,
  POWER_ON,
  POWER_OFF,
  POWER_TOGGLE,
  VOLUME_UP,
  VOLUME_DOWN,
  MUTE,
  CHANNEL_UP,
  CHANNEL_DOWN,

  UP,
  DOWN,
  LEFT,
  RIGHT,
  OK,

  BACK,
  HOME,
  MENU,
  GUIDE,
  SOURCE,

  PLAY,
  PAUSE,
  STOP,
  REWIND,
  FAST_FORWARD,
  PREVIOUS,
  NEXT,

  NUMBER_0,
  NUMBER_1,
  NUMBER_2,
  NUMBER_3,
  NUMBER_4,
  NUMBER_5,
  NUMBER_6,
  NUMBER_7,
  NUMBER_8,
  NUMBER_9,

  EXIT,
  TEXT_INPUT,
  VOICE_INPUT,
}

enum TransportType {
  DIRECT_NETWORK,
  COMPANION_APP,
  BLUETOOTH,
  IR_BLASTER,
  UNSUPPORTED,
}

enum DeviceStatus {
  EXPERIMENTAL,
  TESTING,
  SUPPORTED,
  UNSUPPORTED,
}

class DeviceCapabilities {
  final bool power;
  final bool powerOn;
  final bool powerOff;
  final bool powerToggle;
  final bool wakeOverNetwork;
  final bool volume;
  final bool volumeQuery;
  final bool mute;
  final bool channels;
  final bool navigation;
  final bool source;
  final bool sourceListQuery;
  final bool media;
  final bool keyboard;
  final bool voice;
  final bool companionRequired;

  const DeviceCapabilities({
    required this.power,
    required this.powerOn,
    required this.powerOff,
    required this.powerToggle,
    required this.wakeOverNetwork,
    required this.volume,
    required this.volumeQuery,
    required this.mute,
    required this.channels,
    required this.navigation,
    required this.source,
    required this.sourceListQuery,
    required this.media,
    required this.keyboard,
    required this.voice,
    required this.companionRequired,
  });

  factory DeviceCapabilities.companionDefault() {
    return const DeviceCapabilities(
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
    );
  }

  factory DeviceCapabilities.unknown() {
    return const DeviceCapabilities(
      power: false,
      powerOn: false,
      powerOff: false,
      powerToggle: false,
      wakeOverNetwork: false,
      volume: false,
      volumeQuery: false,
      mute: false,
      channels: false,
      navigation: false,
      source: false,
      sourceListQuery: false,
      media: false,
      keyboard: false,
      voice: false,
      companionRequired: true,
    );
  }

  Map<String, dynamic> toJson() => {
        'power': power,
        'powerOn': powerOn,
        'powerOff': powerOff,
        'powerToggle': powerToggle,
        'wakeOverNetwork': wakeOverNetwork,
        'volume': volume,
        'volumeQuery': volumeQuery,
        'mute': mute,
        'channels': channels,
        'navigation': navigation,
        'source': source,
        'sourceListQuery': sourceListQuery,
        'media': media,
        'keyboard': keyboard,
        'voice': voice,
        'companionRequired': companionRequired,
      };

  factory DeviceCapabilities.fromJson(Map<String, dynamic> json) =>
      DeviceCapabilities(
        power: json['power'] ?? false,
        powerOn: json['powerOn'] ?? false,
        powerOff: json['powerOff'] ?? false,
        powerToggle: json['powerToggle'] ?? false,
        wakeOverNetwork: json['wakeOverNetwork'] ?? false,
        volume: json['volume'] ?? false,
        volumeQuery: json['volumeQuery'] ?? false,
        mute: json['mute'] ?? false,
        channels: json['channels'] ?? false,
        navigation: json['navigation'] ?? false,
        source: json['source'] ?? false,
        sourceListQuery: json['sourceListQuery'] ?? false,
        media: json['media'] ?? false,
        keyboard: json['keyboard'] ?? false,
        voice: json['voice'] ?? false,
        companionRequired: json['companionRequired'] ?? true,
      );
}

class DiscoveredDevice {
  final String deviceId;
  final String name;
  final String manufacturer;
  final String model;
  final String ipAddress;
  final int port;
  final String protocol;
  final DeviceCapabilities capabilities;
  final bool pairingRequired;
  final bool companionRequired;
  final TransportType transportType;
  final String? appVersion;
  final String? protocolVersion;

  const DiscoveredDevice({
    required this.deviceId,
    required this.name,
    required this.manufacturer,
    required this.model,
    required this.ipAddress,
    required this.port,
    required this.protocol,
    required this.capabilities,
    required this.pairingRequired,
    required this.companionRequired,
    required this.transportType,
    this.appVersion,
    this.protocolVersion,
  });

  Map<String, dynamic> toJson() => {
        'deviceId': deviceId,
        'name': name,
        'manufacturer': manufacturer,
        'model': model,
        'ipAddress': ipAddress,
        'port': port,
        'protocol': protocol,
        'capabilities': capabilities.toJson(),
        'pairingRequired': pairingRequired,
        'companionRequired': companionRequired,
        'transportType': transportType.name,
        'appVersion': appVersion,
        'protocolVersion': protocolVersion,
      };

  factory DiscoveredDevice.fromJson(Map<String, dynamic> json) =>
      DiscoveredDevice(
        deviceId: json['deviceId'] ?? '',
        name: json['name'] ?? 'Unknown TV',
        manufacturer: json['manufacturer'] ?? 'Unknown',
        model: json['model'] ?? 'Unknown',
        ipAddress: json['ipAddress'] ?? '',
        port: json['port'] ?? 8888,
        protocol: json['protocol'] ?? 'companion_v1',
        capabilities: DeviceCapabilities.fromJson(json['capabilities'] ?? {}),
        pairingRequired: json['pairingRequired'] ?? true,
        companionRequired: json['companionRequired'] ?? true,
        transportType: TransportType.values.firstWhere(
          (e) => e.name == json['transportType'],
          orElse: () => TransportType.UNSUPPORTED,
        ),
        appVersion: json['appVersion'],
        protocolVersion: json['protocolVersion'],
      );
}

class CommandExecutionResult {
  final bool success;
  final RemoteCommand command;
  final String? reason;
  final int? latencyMs;

  const CommandExecutionResult({
    required this.success,
    required this.command,
    this.reason,
    this.latencyMs,
  });
}

const String companionServiceType = '_smartremote._tcp';
const int companionDefaultPort = 8888;
const String protocolVersion = '1.0';
