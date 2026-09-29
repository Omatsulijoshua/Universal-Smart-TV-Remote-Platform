import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import '../../core/theme/app_colors.dart';

class ChannelControlWidget extends StatelessWidget {
  final Function(RemoteCommand command) onCommand;
  final VoidCallback onKeypadToggle;

  const ChannelControlWidget({
    super.key,
    required this.onCommand,
    required this.onKeypadToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.expand_more_rounded, color: AppColors.textPrimary),
            tooltip: 'CH -',
            onPressed: () => onCommand(RemoteCommand.CHANNEL_DOWN),
          ),
          IconButton(
            icon: const Icon(Icons.dialpad_rounded, color: AppColors.primaryBlue),
            tooltip: 'Keypad',
            onPressed: onKeypadToggle,
          ),
          IconButton(
            icon: const Icon(Icons.expand_less_rounded, color: AppColors.textPrimary),
            tooltip: 'CH +',
            onPressed: () => onCommand(RemoteCommand.CHANNEL_UP),
          ),
        ],
      ),
    );
  }
}
