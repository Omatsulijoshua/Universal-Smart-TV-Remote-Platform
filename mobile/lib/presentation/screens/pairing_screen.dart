import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import '../../core/theme/app_colors.dart';
import '../state/tv_provider.dart';
import 'remote_screen.dart';

class PairingScreen extends StatefulWidget {
  final TvProvider provider;
  final DiscoveredDevice targetDevice;

  const PairingScreen({
    super.key,
    required this.provider,
    required this.targetDevice,
  });

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _isPairing = false;
  String? _errorMessage;

  Future<void> _attemptPairing() async {
    final code = _pinController.text.trim();
    if (code.length < 6) {
      setState(() => _errorMessage = 'Please enter a valid 6-digit code.');
      return;
    }

    setState(() {
      _isPairing = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 900));

    final success = await widget.provider.connectDevice(
      widget.targetDevice,
      sessionToken: 'token-${DateTime.now().millisecondsSinceEpoch}',
    );

    if (!mounted) return;

    setState(() => _isPairing = false);

    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => RemoteScreen(provider: widget.provider)),
        (route) => route.isFirst,
      );
    } else {
      setState(() => _errorMessage = 'Pairing code incorrect or expired. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Pair Device'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3), width: 2),
              ),
              child: const Icon(Icons.lock_person_rounded, size: 56, color: AppColors.primaryBlue),
            ),
            const SizedBox(height: 24),
            Text(
              'Connecting to ${widget.targetDevice.name}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter the 6-digit code displayed on your TV screen',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 36),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 12,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: '482719',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  letterSpacing: 12,
                ),
                filled: true,
                fillColor: AppColors.darkSurfaceCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
                ),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(color: AppColors.accentRed, fontSize: 13),
              ),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _isPairing ? null : _attemptPairing,
                child: _isPairing
                    ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkBackground))
                    : const Text(
                        'Pair & Connect',
                        style: TextStyle(
                          color: AppColors.darkBackground,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
