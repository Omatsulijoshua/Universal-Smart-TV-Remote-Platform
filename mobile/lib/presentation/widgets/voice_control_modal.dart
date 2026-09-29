import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/voice_parser.dart';
import '../state/tv_provider.dart';

class VoiceControlModal extends StatefulWidget {
  final TvProvider provider;
  const VoiceControlModal({super.key, required this.provider});

  @override
  State<VoiceControlModal> createState() => _VoiceControlModalState();
}

class _VoiceControlModalState extends State<VoiceControlModal> {
  bool _isListening = false;
  String _spokenText = '';
  VoiceParserResult? _parseResult;

  void _simulateVoiceListening(String samplePhrase) async {
    setState(() {
      _isListening = true;
      _spokenText = 'Listening...';
      _parseResult = null;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    final parsed = VoiceIntentParser.parse(samplePhrase);

    if (mounted) {
      setState(() {
        _isListening = false;
        _spokenText = samplePhrase;
        _parseResult = parsed;
      });

      if (parsed.isSupported && parsed.command != null) {
        widget.provider.sendCommand(parsed.command!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Voice Remote Control',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap mic and speak a TV command (e.g. "Volume up", "Go home", "Pause")',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => _simulateVoiceListening('Volume up'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: _isListening ? AppColors.accentRed : AppColors.primaryBlue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_isListening ? AppColors.accentRed : AppColors.primaryBlue).withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 4,
                  )
                ],
              ),
              child: const Icon(Icons.mic_rounded, size: 48, color: AppColors.darkBackground),
            ),
          ),
          const SizedBox(height: 20),
          if (_spokenText.isNotEmpty) ...[
            Text(
              '"$_spokenText"',
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
          ],
          if (_parseResult != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _parseResult!.isSupported ? AppColors.darkSurfaceCard : AppColors.accentRed.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _parseResult!.isSupported ? AppColors.accentGreen : AppColors.accentRed,
                  width: 1,
                ),
              ),
              child: Text(
                _parseResult!.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _parseResult!.isSupported ? AppColors.accentGreen : AppColors.accentRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Wrap(
            spacing: 8,
            children: [
              ActionChip(
                label: const Text('Volume up'),
                onPressed: () => _simulateVoiceListening('Volume up'),
              ),
              ActionChip(
                label: const Text('Go home'),
                onPressed: () => _simulateVoiceListening('Go home'),
              ),
              ActionChip(
                label: const Text('Pause'),
                onPressed: () => _simulateVoiceListening('Pause'),
              ),
              ActionChip(
                label: const Text('Unsupported command'),
                onPressed: () => _simulateVoiceListening('Play Netflix movie'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
