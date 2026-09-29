import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import '../../core/theme/app_colors.dart';
import '../state/tv_provider.dart';
import 'pairing_screen.dart';

class DiscoveryScreen extends StatefulWidget {
  final TvProvider provider;
  const DiscoveryScreen({super.key, required this.provider});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.provider.startDiscovery();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.provider,
      builder: (context, _) {
        final isSearching = widget.provider.isSearching;
        final discoveredList = widget.provider.discoveredDevices;

        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          appBar: AppBar(
            title: const Text('Local Network Discovery'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
                onPressed: () => widget.provider.startDiscovery(),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isSearching) ...[
                  Row(
                    children: const [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Searching for TVs...',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Scanning local network via mDNS & companion service discovery',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                ] else ...[
                  const Text(
                    'TVs Found',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Expanded(
                  child: discoveredList.isEmpty && !isSearching
                      ? _buildNoResultsView()
                      : ListView.builder(
                          itemCount: discoveredList.length,
                          itemBuilder: (context, index) {
                            final tv = discoveredList[index];
                            return _buildDiscoveredCard(context, tv);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoResultsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          const Text(
            'No TVs Found',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ensure your TV is turned on and connected\nto the same Wi-Fi network.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
            onPressed: () => widget.provider.startDiscovery(),
            child: const Text('Search Again', style: TextStyle(color: AppColors.darkBackground)),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveredCard(BuildContext context, DiscoveredDevice tv) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.tv_rounded, color: AppColors.primaryBlue, size: 28),
        ),
        title: Text(
          tv.name,
          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${tv.manufacturer} ${tv.model} • ${tv.ipAddress}:${tv.port}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: [
                _badge(tv.protocol, AppColors.primaryBlue),
                if (tv.companionRequired) _badge('Companion Required', Colors.orange),
              ],
            )
          ],
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PairingScreen(provider: widget.provider, targetDevice: tv),
              ),
            );
          },
          child: const Text('Connect', style: TextStyle(color: AppColors.darkBackground, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
