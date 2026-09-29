import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import '../../core/theme/app_colors.dart';

class AppShortcutsWidget extends StatelessWidget {
  final Function(RemoteCommand command) onCommand;

  const AppShortcutsWidget({
    super.key,
    required this.onCommand,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 10),
            child: Text(
              'App Shortcuts',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _appButton('YouTube', Colors.red, Icons.play_circle_fill_rounded, RemoteCommand.APP_YOUTUBE),
              _appButton('Netflix', const Color(0xFFE50914), Icons.movie_rounded, RemoteCommand.APP_NETFLIX),
              _appButton('Hulu', const Color(0xFF1CE783), Icons.tv_rounded, RemoteCommand.APP_HULU),
              _appButton('Prime', const Color(0xFF00A8E1), Icons.video_library_rounded, RemoteCommand.APP_PRIME_VIDEO),
              _appButton('Disney+', const Color(0xFF113CCF), Icons.auto_awesome_rounded, RemoteCommand.APP_DISNEY_PLUS),
            ],
          ),
        ],
      ),
    );
  }

  Widget _appButton(String label, Color color, IconData icon, RemoteCommand command) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onCommand(command),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
