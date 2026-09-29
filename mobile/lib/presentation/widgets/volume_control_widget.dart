import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import '../../core/theme/app_colors.dart';

class VolumeControlWidget extends StatelessWidget {
  final Function(RemoteCommand command) onCommand;
  final bool volumeQuerySupported;
  final int currentVolume;

  const VolumeControlWidget({
    super.key,
    required this.onCommand,
    required this.volumeQuerySupported,
    required this.currentVolume,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          if (volumeQuerySupported) ...[
            Text(
              'Volume $currentVolume',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_rounded, color: AppColors.textPrimary),
                tooltip: 'VOL -',
                onPressed: () => onCommand(RemoteCommand.VOLUME_DOWN),
              ),
              IconButton(
                icon: const Icon(Icons.volume_off_rounded, color: AppColors.accentRed),
                tooltip: 'Mute',
                onPressed: () => onCommand(RemoteCommand.MUTE),
              ),
              IconButton(
                icon: const Icon(Icons.add_rounded, color: AppColors.textPrimary),
                tooltip: 'VOL +',
                onPressed: () => onCommand(RemoteCommand.VOLUME_UP),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
