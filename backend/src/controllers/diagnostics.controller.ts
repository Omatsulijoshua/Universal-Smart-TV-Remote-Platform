import { Controller, Get, Post, Body } from '@nestjs/common';
import { BackendDataStore } from '../services/data.store';
import { DiagnosticEventEntity } from '../entities/database.entities';

@Controller('diagnostics')
export class DiagnosticsController {
  private dataStore = BackendDataStore.getInstance();

  @Get()
  getDiagnosticEvents(): DiagnosticEventEntity[] {
    return this.dataStore.diagnosticEvents;
  }

  @Post('event')
  logDiagnosticEvent(@Body() body: Partial<DiagnosticEventEntity>): { success: boolean; id: string } {
    const event: DiagnosticEventEntity = {
      id: `evt-${Date.now()}`,
      phoneDeviceId: body.phoneDeviceId || 'anonymous-phone',
      tvDeviceId: body.tvDeviceId,
      eventType: body.eventType || 'REMOTE_COMMAND',
      transport: body.transport || 'COMPANION',
      success: body.success ?? true,
      latencyMs: body.latencyMs,
      errorMessage: body.errorMessage,
      createdAt: new Date(),
    };
    this.dataStore.diagnosticEvents.push(event);
    return { success: true, id: event.id };
  }
}
