import 'package:shared/shared.dart';

class IrCodeSignal {
  final String manufacturer;
  final String model;
  final String protocol;
  final int frequency;
  final RemoteCommand command;
  final List<int> pattern;

  const IrCodeSignal({
    required this.manufacturer,
    required this.model,
    required this.protocol,
    required this.frequency,
    required this.command,
    required this.pattern,
  });
}

class IrCodeDatabase {
  static final List<IrCodeSignal> _signals = [
    // Hikers TV NEC Protocol (38kHz carrier)
    const IrCodeSignal(
      manufacturer: 'Hikers',
      model: 'Android TV',
      protocol: 'NEC',
      frequency: 38000,
      command: RemoteCommand.POWER_TOGGLE,
      pattern: [9000, 4500, 560, 560, 560, 1690, 560, 560],
    ),
    const IrCodeSignal(
      manufacturer: 'Hikers',
      model: 'Android TV',
      protocol: 'NEC',
      frequency: 38000,
      command: RemoteCommand.VOLUME_UP,
      pattern: [9000, 4500, 560, 1690, 560, 560, 560, 1690],
    ),
    const IrCodeSignal(
      manufacturer: 'Hikers',
      model: 'Android TV',
      protocol: 'NEC',
      frequency: 38000,
      command: RemoteCommand.VOLUME_DOWN,
      pattern: [9000, 4500, 560, 1690, 560, 1690, 560, 560],
    ),
    const IrCodeSignal(
      manufacturer: 'Hikers',
      model: 'Android TV',
      protocol: 'NEC',
      frequency: 38000,
      command: RemoteCommand.MUTE,
      pattern: [9000, 4500, 560, 560, 560, 1690, 560, 1690],
    ),

    // Generic TV RC5 Protocol (36kHz carrier)
    const IrCodeSignal(
      manufacturer: 'Generic',
      model: 'Smart TV',
      protocol: 'RC5',
      frequency: 36000,
      command: RemoteCommand.POWER_TOGGLE,
      pattern: [889, 889, 1778, 889, 889, 889],
    ),
  ];

  static IrCodeSignal? lookupSignal(String manufacturer, RemoteCommand command) {
    try {
      return _signals.firstWhere(
        (s) => s.manufacturer.toLowerCase() == manufacturer.toLowerCase() && s.command == command,
      );
    } catch (_) {
      try {
        return _signals.firstWhere((s) => s.command == command);
      } catch (_) {
        return null;
      }
    }
  }

  static List<IrCodeSignal> getAllSignalsForManufacturer(String manufacturer) {
    return _signals.where((s) => s.manufacturer.toLowerCase() == manufacturer.toLowerCase()).toList();
  }
}
