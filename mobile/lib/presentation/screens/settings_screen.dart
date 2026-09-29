import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../state/tv_provider.dart';

class SettingsScreen extends StatelessWidget {
  final TvProvider provider;
  const SettingsScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: provider,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          appBar: AppBar(
            title: const Text('Settings'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Feedback & Vibration',
                style: TextStyle(color: AppColors.primaryBlue, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Haptic Vibration Feedback', style: TextStyle(color: AppColors.textPrimary)),
                subtitle: const Text('Vibrate phone on remote button press', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                value: provider.hapticsEnabled,
                activeThumbColor: AppColors.primaryBlue,
                onChanged: (val) => provider.toggleHaptics(val),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Sound Feedback', style: TextStyle(color: AppColors.textPrimary)),
                subtitle: const Text('Play click audio sound on button press', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                value: provider.soundEnabled,
                activeThumbColor: AppColors.primaryBlue,
                onChanged: (val) => provider.toggleSound(val),
              ),
              const Divider(color: AppColors.darkSurfaceCard, height: 32),
              const Text(
                'Appearance',
                style: TextStyle(color: AppColors.primaryBlue, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Theme', style: TextStyle(color: AppColors.textPrimary)),
                subtitle: const Text('Dark Mode (Consumer Electronics)', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                trailing: const Icon(Icons.dark_mode_rounded, color: AppColors.primaryBlue),
              ),
              const Divider(color: AppColors.darkSurfaceCard, height: 32),
              const Text(
                'TV Management',
                style: TextStyle(color: AppColors.primaryBlue, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Saved TVs', style: TextStyle(color: AppColors.textPrimary)),
                subtitle: Text('${provider.savedDevices.length} TV(s) saved', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      },
    );
  }
}
