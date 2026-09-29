import 'package:flutter/material.dart';
import '../service/companion_service.dart';
import 'tv_theme.dart';

class PairingView extends StatelessWidget {
  final TvCompanionService service;
  const PairingView({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final code = service.currentPairingCode ?? '482 719';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
      child: Row(
        children: [
          // Left side: Pairing PIN details
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: TvTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.tv_rounded, color: TvTheme.primaryBlue, size: 36),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Universal TV Remote', style: Theme.of(context).textTheme.headlineMedium),
                        const Text('Companion Service Active', style: TextStyle(color: TvTheme.accentGreen, fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                const Text('Pair your phone', style: TextStyle(color: TvTheme.textSecondary, fontSize: 20)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  decoration: BoxDecoration(
                    color: TvTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: TvTheme.primaryBlue.withValues(alpha: 0.4), width: 2),
                  ),
                  child: Text(
                    code,
                    style: const TextStyle(
                      color: TvTheme.textPrimary,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: const [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(TvTheme.primaryBlue),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Waiting for phone connection...',
                      style: TextStyle(color: TvTheme.textSecondary, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),

          // Right side: QR Code & Simulate Connection Button
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 220,
                  height: 220,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_2_rounded, color: Colors.black, size: 140),
                      const SizedBox(height: 8),
                      const Text(
                        'Scan with Phone',
                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: const Icon(Icons.phonelink_ring_rounded),
                        label: const Text('Simulate Phone Connection', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          service.verifyPairingCode(code);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
