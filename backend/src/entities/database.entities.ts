/**
 * Database Entity Definitions for PostgreSQL (TypeORM/Prisma compatible)
 */

export interface UserEntity {
  id: string;
  email?: string;
  anonymousId: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface DeviceEntity {
  id: string;
  userId?: string;
  platform: 'android' | 'ios';
  model: string;
  osVersion: string;
  appVersion: string;
  hasIrBlaster: boolean;
  createdAt: Date;
}

export interface TvBrandEntity {
  id: string;
  name: string;
  logoUrl?: string;
  status: 'EXPERIMENTAL' | 'TESTING' | 'SUPPORTED' | 'UNSUPPORTED';
  createdAt: Date;
  updatedAt: Date;
}

export interface TvModelEntity {
  id: string;
  brandId: string;
  model: string;
  platform: 'Android TV' | 'Google TV' | 'Tizen' | 'webOS' | 'Roku' | 'Proprietary';
  protocol: string;
  capabilities: Record<string, boolean>;
  companionRequired: boolean;
  status: 'EXPERIMENTAL' | 'TESTING' | 'SUPPORTED' | 'UNSUPPORTED';
  createdAt: Date;
  updatedAt: Date;
}

export interface ProtocolEntity {
  id: string;
  name: string;
  code: string;
  description: string;
  defaultPort: number;
  transportType: string;
  pairingRequired: boolean;
  version: string;
}

export interface ProtocolCapabilityEntity {
  id: string;
  protocolId: string;
  capabilityKey: string;
  isSupported: boolean;
}

export interface PairingEntity {
  id: string;
  tvDeviceId: string;
  phoneDeviceId: string;
  sessionTokenHash: string;
  expiresAt: Date;
  revoked: boolean;
  createdAt: Date;
}

export interface SubscriptionEntity {
  id: string;
  userId: string;
  tier: 'FREE' | 'PREMIUM';
  active: boolean;
  expiresAt?: Date;
  createdAt: Date;
}

export interface AppConfigurationEntity {
  id: string;
  configKey: string;
  configValue: string;
  updatedAt: Date;
}

export interface DiagnosticEventEntity {
  id: string;
  phoneDeviceId: string;
  tvDeviceId?: string;
  eventType: string;
  transport: string;
  success: boolean;
  latencyMs?: number;
  errorMessage?: string;
  createdAt: Date;
}

export interface RemoteSessionEntity {
  id: string;
  tvDeviceId: string;
  phoneDeviceId: string;
  startedAt: Date;
  endedAt?: Date;
  commandCount: number;
}
