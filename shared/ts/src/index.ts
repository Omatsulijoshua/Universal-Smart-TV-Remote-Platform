/**
 * Universal Smart TV Remote Protocol & Domain Definitions
 */

export enum RemoteCommand {
  POWER = 'POWER',
  POWER_ON = 'POWER_ON',
  POWER_OFF = 'POWER_OFF',
  POWER_TOGGLE = 'POWER_TOGGLE',
  VOLUME_UP = 'VOLUME_UP',
  VOLUME_DOWN = 'VOLUME_DOWN',
  MUTE = 'MUTE',
  CHANNEL_UP = 'CHANNEL_UP',
  CHANNEL_DOWN = 'CHANNEL_DOWN',

  UP = 'UP',
  DOWN = 'DOWN',
  LEFT = 'LEFT',
  RIGHT = 'RIGHT',
  OK = 'OK',

  BACK = 'BACK',
  HOME = 'HOME',
  MENU = 'MENU',
  GUIDE = 'GUIDE',
  SOURCE = 'SOURCE',

  PLAY = 'PLAY',
  PAUSE = 'PAUSE',
  STOP = 'STOP',
  REWIND = 'REWIND',
  FAST_FORWARD = 'FAST_FORWARD',
  PREVIOUS = 'PREVIOUS',
  NEXT = 'NEXT',

  NUMBER_0 = 'NUMBER_0',
  NUMBER_1 = 'NUMBER_1',
  NUMBER_2 = 'NUMBER_2',
  NUMBER_3 = 'NUMBER_3',
  NUMBER_4 = 'NUMBER_4',
  NUMBER_5 = 'NUMBER_5',
  NUMBER_6 = 'NUMBER_6',
  NUMBER_7 = 'NUMBER_7',
  NUMBER_8 = 'NUMBER_8',
  NUMBER_9 = 'NUMBER_9',

  EXIT = 'EXIT',
  TEXT_INPUT = 'TEXT_INPUT',
  VOICE_INPUT = 'VOICE_INPUT'
}

export enum TransportType {
  DIRECT_NETWORK = 'DIRECT_NETWORK',
  COMPANION_APP = 'COMPANION_APP',
  BLUETOOTH = 'BLUETOOTH',
  IR_BLASTER = 'IR_BLASTER',
  UNSUPPORTED = 'UNSUPPORTED'
}

export enum DeviceStatus {
  EXPERIMENTAL = 'EXPERIMENTAL',
  TESTING = 'TESTING',
  SUPPORTED = 'SUPPORTED',
  UNSUPPORTED = 'UNSUPPORTED'
}

export interface DeviceCapabilities {
  power: boolean;
  powerOn: boolean;
  powerOff: boolean;
  powerToggle: boolean;
  wakeOverNetwork: boolean;
  volume: boolean;
  volumeQuery: boolean;
  mute: boolean;
  channels: boolean;
  navigation: boolean;
  source: boolean;
  sourceListQuery: boolean;
  media: boolean;
  keyboard: boolean;
  voice: boolean;
  companionRequired: boolean;
}

export interface DiscoveredDevice {
  deviceId: string;
  name: string;
  manufacturer: string;
  model: string;
  ipAddress: string;
  port: number;
  protocol: string;
  capabilities: DeviceCapabilities;
  pairingRequired: boolean;
  companionRequired: boolean;
  transportType: TransportType;
  appVersion?: string;
  protocolVersion?: string;
}

export interface PairingPayload {
  pairingCode: string;
  phoneDeviceId: string;
  phoneName: string;
  timestamp: number;
  expiresAt: number;
}

export interface PairingResponse {
  success: boolean;
  sessionToken?: string;
  publicKey?: string;
  error?: string;
}

export interface CommandPayload {
  command: RemoteCommand;
  text?: string;
  sessionId?: string;
  timestamp: number;
}

export interface CommandExecutionResult {
  success: boolean;
  command: RemoteCommand;
  reason?: string;
  latencyMs?: number;
}

export const COMPANION_SERVICE_TYPE = '_smartremote._tcp';
export const COMPANION_DEFAULT_PORT = 8888;
export const PROTOCOL_VERSION = '1.0';
