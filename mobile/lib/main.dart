import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/state/tv_provider.dart';
import 'presentation/screens/splash_screen.dart';

void main() {
  runApp(const SmartTvRemoteApp());
}

class SmartTvRemoteApp extends StatefulWidget {
  const SmartTvRemoteApp({super.key});

  @override
  State<SmartTvRemoteApp> createState() => _SmartTvRemoteAppState();
}

class _SmartTvRemoteAppState extends State<SmartTvRemoteApp> {
  final TvProvider _tvProvider = TvProvider();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universal TV Remote',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: SplashScreen(provider: _tvProvider),
    );
  }
}
