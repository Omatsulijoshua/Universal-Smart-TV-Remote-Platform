import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import '../service/companion_service.dart';
import 'tv_theme.dart';

class ConnectedView extends StatelessWidget {
  final TvCompanionService service;
  const ConnectedView({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final phone = service.connectedPhone;
    final phoneName = phone?.phoneName ?? "Joshua's Phone";
    final ipAddress = phone?.ipAddress ?? '192.168.1.105';
    final historyLogs = service.commandHistoryLogs;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
      child: Row(
        children: [
          // Left Side: Connection details & actions
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(Icons.circle, color: TvTheme.accentGreen, size: 16),
                    const SizedBox(width: 12),
                    Text('Phone Connected', style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
                const SizedBox(height: 24),
                Card(
                  color: TvTheme.surfaceCard,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: TvTheme.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.smartphone_rounded, color: TvTheme.primaryBlue, size: 40),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(phoneName, style: const TextStyle(color: TvTheme.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('IP: $ipAddress • Encrypted Session Active', style: const TextStyle(color: TvTheme.textSecondary, fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 16,
                  children: [
                    Focus(
                      autofocus: true,
                      child: Builder(
                        builder: (context) {
                          final hasFocus = Focus.of(context).hasFocus;
                          return ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: hasFocus ? TvTheme.primaryBlue : TvTheme.surfaceCard,
                              foregroundColor: hasFocus ? Colors.black : TvTheme.textPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.touch_app_rounded),
                            label: const Text('Simulate Command Received', style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: () {
                              service.handleIncomingCommand(RemoteCommand.VOLUME_UP);
                            },
                          );
                        },
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.withValues(alpha: 0.2),
                        foregroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.link_off_rounded),
                      label: const Text('Disconnect Phone'),
                      onPressed: () {
                        service.disconnectPhone();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),

          // Right Side: Command Execution Log
          Expanded(
            flex: 2,
            child: Card(
              color: TvTheme.surfaceCard,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.terminal_rounded, color: TvTheme.primaryBlue, size: 20),
                        SizedBox(width: 8),
                        Text('Command Execution Stream', style: TextStyle(color: TvTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: historyLogs.isEmpty
                          ? const Center(child: Text('No commands received yet', style: TextStyle(color: TvTheme.textSecondary)))
                          : ListView.builder(
                              itemCount: historyLogs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    historyLogs[index],
                                    style: const TextStyle(
                                      color: TvTheme.accentGreen,
                                      fontSize: 12,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
