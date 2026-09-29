import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared/shared.dart';
import '../../core/theme/app_colors.dart';

class DPadWidget extends StatelessWidget {
  final Function(RemoteCommand command) onCommand;
  final bool hapticsEnabled;

  const DPadWidget({
    super.key,
    required this.onCommand,
    required this.hapticsEnabled,
  });

  void _trigger(RemoteCommand command) {
    if (hapticsEnabled) {
      HapticFeedback.lightImpact();
    }
    onCommand(command);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceCard,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            spreadRadius: 2,
          )
        ],
      ),
      child: Stack(
        children: [
          // Up
          Align(
            alignment: Alignment.topCenter,
            child: IconButton(
              iconSize: 40,
              icon: const Icon(Icons.arrow_drop_up_rounded, color: AppColors.textPrimary),
              onPressed: () => _trigger(RemoteCommand.UP),
            ),
          ),
          // Down
          Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              iconSize: 40,
              icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.textPrimary),
              onPressed: () => _trigger(RemoteCommand.DOWN),
            ),
          ),
          // Left
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              iconSize: 40,
              icon: const Icon(Icons.arrow_left_rounded, color: AppColors.textPrimary),
              onPressed: () => _trigger(RemoteCommand.LEFT),
            ),
          ),
          // Right
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              iconSize: 40,
              icon: const Icon(Icons.arrow_right_rounded, color: AppColors.textPrimary),
              onPressed: () => _trigger(RemoteCommand.RIGHT),
            ),
          ),
          // OK Center
          Center(
            child: GestureDetector(
              onTap: () => _trigger(RemoteCommand.OK),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.4),
                      blurRadius: 12,
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: AppColors.darkBackground,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
