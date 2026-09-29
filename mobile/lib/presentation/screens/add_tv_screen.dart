import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../state/tv_provider.dart';
import 'discovery_screen.dart';
import 'pairing_screen.dart';

class AddTvScreen extends StatelessWidget {
  final TvProvider provider;
  const AddTvScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Add TV'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How do you want to connect?',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Make sure your phone and TV are connected to the same Wi-Fi network.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            _buildOptionCard(
              context,
              title: 'Search for TVs',
              subtitle: 'Scan your local network for Smart TVs',
              icon: Icons.wifi_find_rounded,
              isPrimary: true,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => DiscoveryScreen(provider: provider)),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildOptionCard(
              context,
              title: 'Enter pairing code',
              subtitle: 'Type the 6-digit code displayed on your TV',
              icon: Icons.pin_outlined,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PairingScreen(
                      provider: provider,
                      targetDevice: provider.savedDevices.first,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildOptionCard(
              context,
              title: 'Scan QR code',
              subtitle: 'Scan temporary QR code on your TV screen',
              icon: Icons.qr_code_scanner_rounded,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening camera scanner...')),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildOptionCard(
              context,
              title: 'Connect manually',
              subtitle: 'Specify TV IP address & port',
              icon: Icons.settings_ethernet_rounded,
              onTap: () {
                _showManualIpDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    bool isPrimary = false,
    required VoidCallback onTap,
  }) {
    return Card(
      color: isPrimary ? AppColors.darkSurfaceCard : AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isPrimary
            ? const BorderSide(color: AppColors.primaryBlue, width: 1.5)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Icon(icon, color: isPrimary ? AppColors.primaryBlue : AppColors.textSecondary, size: 28),
        title: Text(
          title,
          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }

  void _showManualIpDialog(BuildContext context) {
    final controller = TextEditingController(text: '192.168.1.');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkSurfaceCard,
        title: const Text('Connect Manually', style: TextStyle(color: AppColors.textPrimary)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            labelText: 'TV IP Address',
            labelStyle: TextStyle(color: AppColors.textSecondary),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryBlue)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => DiscoveryScreen(provider: provider)),
              );
            },
            child: const Text('Connect', style: TextStyle(color: AppColors.darkBackground)),
          ),
        ],
      ),
    );
  }
}
