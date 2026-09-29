import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import '../../core/theme/app_colors.dart';
import '../state/tv_provider.dart';
import '../widgets/dpad_widget.dart';
import '../widgets/volume_control_widget.dart';
import '../widgets/channel_control_widget.dart';
import '../widgets/keyboard_input_dialog.dart';
import '../widgets/voice_control_modal.dart';
import 'settings_screen.dart';

class RemoteScreen extends StatefulWidget {
  final TvProvider provider;
  const RemoteScreen({super.key, required this.provider});

  @override
  State<RemoteScreen> createState() => _RemoteScreenState();
}

class _RemoteScreenState extends State<RemoteScreen> {
  bool _showNumericKeypad = false;

  void _onButtonPress(RemoteCommand command, {String? text}) {
    widget.provider.sendCommand(command, text: text);
  }

  void _openKeyboardInput() {
    showDialog(
      context: context,
      builder: (context) => KeyboardInputDialog(
        onSendText: (text) {
          _onButtonPress(RemoteCommand.TEXT_INPUT, text: text);
        },
      ),
    );
  }

  void _openVoiceControl() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => VoiceControlModal(provider: widget.provider),
    );
  }

  void _openSourceModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Input Source', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.tv_rounded, color: AppColors.primaryBlue),
                title: const Text('TV', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  _onButtonPress(RemoteCommand.SOURCE, text: 'TV');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cable_rounded, color: AppColors.primaryBlue),
                title: const Text('HDMI 1', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  _onButtonPress(RemoteCommand.SOURCE, text: 'HDMI 1');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cable_rounded, color: AppColors.primaryBlue),
                title: const Text('HDMI 2', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  _onButtonPress(RemoteCommand.SOURCE, text: 'HDMI 2');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.usb_rounded, color: AppColors.primaryBlue),
                title: const Text('USB', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  _onButtonPress(RemoteCommand.SOURCE, text: 'USB');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.provider,
      builder: (context, _) {
        final connectedDevice = widget.provider.connectedDevice;
        final controller = widget.provider.remoteController;
        final tvName = connectedDevice?.name ?? 'Hikers TV';

        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.circle, color: AppColors.accentGreen, size: 10),
                const SizedBox(width: 8),
                Text(tvName),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.keyboard_outlined, color: AppColors.textPrimary),
                tooltip: 'Keyboard',
                onPressed: controller.isCapabilitySupported(RemoteCommand.TEXT_INPUT) ? _openKeyboardInput : null,
              ),
              IconButton(
                icon: const Icon(Icons.mic_none_rounded, color: AppColors.textPrimary),
                tooltip: 'Voice Control',
                onPressed: _openVoiceControl,
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
                tooltip: 'Settings',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => SettingsScreen(provider: widget.provider)),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                // Power Button per Section 13 & 24
                if (controller.isCapabilitySupported(RemoteCommand.POWER)) ...[
                  IconButton(
                    iconSize: 52,
                    icon: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.accentRed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.power_settings_new_rounded, color: Colors.white, size: 28),
                    ),
                    onPressed: () => _onButtonPress(RemoteCommand.POWER_TOGGLE),
                  ),
                  const SizedBox(height: 16),
                ],

                // D-Pad per Section 15
                if (controller.isCapabilitySupported(RemoteCommand.UP)) ...[
                  DPadWidget(
                    onCommand: _onButtonPress,
                    hapticsEnabled: widget.provider.hapticsEnabled,
                  ),
                  const SizedBox(height: 24),
                ],

                // Volume Control per Section 16
                if (controller.isCapabilitySupported(RemoteCommand.VOLUME_UP)) ...[
                  VolumeControlWidget(
                    onCommand: _onButtonPress,
                    volumeQuerySupported: connectedDevice?.capabilities.volumeQuery ?? false,
                    currentVolume: widget.provider.lastVolumeLevel,
                  ),
                  const SizedBox(height: 12),
                ],

                // Channel Control & Numeric Keypad per Section 17
                if (controller.isCapabilitySupported(RemoteCommand.CHANNEL_UP)) ...[
                  ChannelControlWidget(
                    onCommand: _onButtonPress,
                    onKeypadToggle: () {
                      setState(() => _showNumericKeypad = !_showNumericKeypad);
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                if (_showNumericKeypad) ...[
                  _buildNumericKeypad(),
                  const SizedBox(height: 12),
                ],

                // Navigation Bar: HOME, BACK, MENU, GUIDE per Section 13 & 14
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _navIconButton('HOME', Icons.home_rounded, RemoteCommand.HOME),
                    _navIconButton('BACK', Icons.arrow_back_rounded, RemoteCommand.BACK),
                    _navIconButton('MENU', Icons.menu_rounded, RemoteCommand.MENU),
                    _navIconButton('GUIDE', Icons.grid_view_rounded, RemoteCommand.GUIDE),
                  ],
                ),
                const SizedBox(height: 12),

                // Source & Extras per Section 18
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _navIconButton('SOURCE', Icons.input_rounded, RemoteCommand.SOURCE, onTapOverride: _openSourceModal),
                    _navIconButton('MEDIA', Icons.play_arrow_rounded, RemoteCommand.PLAY),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _navIconButton(String label, IconData icon, RemoteCommand command, {VoidCallback? onTapOverride}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: AppColors.darkSurfaceCard,
            padding: const EdgeInsets.all(14),
          ),
          icon: Icon(icon, color: AppColors.textPrimary, size: 24),
          onPressed: onTapOverride ?? () => _onButtonPress(command),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildNumericKeypad() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: [
          ...List.generate(9, (index) {
            final num = index + 1;
            return _numButton('$num', RemoteCommand.values.firstWhere((e) => e.name == 'NUMBER_$num'));
          }),
          const SizedBox.shrink(),
          _numButton('0', RemoteCommand.NUMBER_0),
          const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _numButton(String label, RemoteCommand command) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () => _onButtonPress(command),
      child: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
