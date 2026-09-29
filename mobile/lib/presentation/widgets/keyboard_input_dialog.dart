import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class KeyboardInputDialog extends StatefulWidget {
  final Function(String text) onSendText;
  const KeyboardInputDialog({super.key, required this.onSendText});

  @override
  State<KeyboardInputDialog> createState() => _KeyboardInputDialogState();
}

class _KeyboardInputDialogState extends State<KeyboardInputDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.darkSurfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('TV Keyboard Input', style: TextStyle(color: AppColors.textPrimary)),
      content: TextField(
        controller: _controller,
        autofocus: true,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: const InputDecoration(
          hintText: 'Type text here to send to TV...',
          hintStyle: TextStyle(color: AppColors.textSecondary),
          border: OutlineInputBorder(),
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            widget.onSendText(value);
            Navigator.pop(context);
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onSendText(_controller.text);
              Navigator.pop(context);
            }
          },
          child: const Text('Send', style: TextStyle(color: AppColors.darkBackground, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
