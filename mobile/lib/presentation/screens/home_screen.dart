import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../state/tv_provider.dart';
import 'add_tv_screen.dart';
import 'remote_screen.dart';
import 'settings_screen.dart';
import 'diagnostics_screen.dart';
import 'package:shared/shared.dart';

class HomeScreen extends StatefulWidget {
  final TvProvider provider;
  const HomeScreen({super.key, required this.provider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.provider,
      builder: (context, _) {
        final savedTvList = widget.provider.savedDevices;
        final connectedDevice = widget.provider.connectedDevice;

        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const Text(
                  'My TVs',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.analytics_outlined, color: AppColors.textSecondary),
                tooltip: 'Diagnostics',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => DiagnosticsScreen(provider: widget.provider)),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
                tooltip: 'Settings',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => SettingsScreen(provider: widget.provider)),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: savedTvList.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          itemCount: savedTvList.length,
                          itemBuilder: (context, index) {
                            final tv = savedTvList[index];
                            final isConnected = connectedDevice?.deviceId == tv.deviceId;
                            return _buildTvCard(context, tv, isConnected);
                          },
                        ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.add_rounded, color: AppColors.darkBackground),
                    label: const Text(
                      '+ Add TV',
                      style: TextStyle(
                        color: AppColors.darkBackground,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AddTvScreen(provider: widget.provider)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.darkSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.tv_off_rounded, size: 64, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          const Text(
            'No TV Connected',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Connect your first TV and start\ncontrolling it from your phone.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTvCard(BuildContext context, DiscoveredDevice tv, bool isConnected) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tv_rounded, color: AppColors.primaryBlue, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tv.name,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${tv.manufacturer} • ${tv.ipAddress}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
                  onPressed: () => _showTvOptionsModal(context, tv),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 10,
                  color: isConnected ? AppColors.accentGreen : AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  isConnected ? 'Connected' : 'Offline',
                  style: TextStyle(
                    color: isConnected ? AppColors.accentGreen : AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isConnected ? AppColors.primaryBlue : AppColors.darkSurface,
                    foregroundColor: isConnected ? AppColors.darkBackground : AppColors.textPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    if (!isConnected) {
                      await widget.provider.connectDevice(tv);
                    }
                    if (context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => RemoteScreen(provider: widget.provider)),
                      );
                    }
                  },
                  child: Text(isConnected ? 'Open Remote' : 'Connect'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTvOptionsModal(BuildContext context, DiscoveredDevice tv) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
                title: const Text('Rename TV', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline_rounded, color: AppColors.textPrimary),
                title: const Text('View Capabilities', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(context);
                  _showCapabilitiesDialog(context, tv);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: AppColors.accentRed),
                title: const Text('Forget TV', style: TextStyle(color: AppColors.accentRed)),
                onTap: () {
                  widget.provider.forgetDevice(tv.deviceId);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCapabilitiesDialog(BuildContext context, DiscoveredDevice tv) {
    final caps = tv.capabilities;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkSurfaceCard,
        title: Text('${tv.name} Capabilities', style: const TextStyle(color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _capRow('Power Toggle', caps.power),
            _capRow('Volume Control', caps.volume),
            _capRow('Navigation / D-Pad', caps.navigation),
            _capRow('Source Input Selection', caps.source),
            _capRow('Keyboard Input', caps.keyboard),
            _capRow('Voice Remote Control', caps.voice),
            _capRow('Requires Companion App', caps.companionRequired),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppColors.primaryBlue)),
          ),
        ],
      ),
    );
  }

  Widget _capRow(String label, bool supported) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            supported ? Icons.check_circle_outline_rounded : Icons.cancel_outlined,
            color: supported ? AppColors.accentGreen : AppColors.accentRed,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
        ],
      ),
    );
  }
}
