import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'service/companion_service.dart';
import 'ui/tv_theme.dart';
import 'ui/pairing_view.dart';
import 'ui/connected_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const TvCompanionApp());
}

class TvCompanionApp extends StatefulWidget {
  const TvCompanionApp({super.key});

  @override
  State<TvCompanionApp> createState() => _TvCompanionAppState();
}

class _TvCompanionAppState extends State<TvCompanionApp> {
  final TvCompanionService _service = TvCompanionService();

  @override
  void initState() {
    super.initState();
    _service.startAdvertising();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universal TV Remote Companion',
      debugShowCheckedModeBanner: false,
      theme: TvTheme.theme,
      home: Scaffold(
        body: ListenableBuilder(
          listenable: _service,
          builder: (context, _) {
            if (_service.isConnected) {
              return ConnectedView(service: _service);
            }
            return PairingView(service: _service);
          },
        ),
      ),
    );
  }
}
