import 'package:shared/shared.dart';

class VoiceParserResult {
  final RemoteCommand? command;
  final String text;
  final bool isSupported;
  final String message;

  VoiceParserResult({
    this.command,
    required this.text,
    required this.isSupported,
    required this.message,
  });
}

class VoiceIntentParser {
  static VoiceParserResult parse(String spokenText) {
    final lower = spokenText.trim().toLowerCase();

    if (lower.contains('volume up') || lower.contains('increase volume') || lower.contains('louder')) {
      return VoiceParserResult(
        command: RemoteCommand.VOLUME_UP,
        text: spokenText,
        isSupported: true,
        message: 'Executing Volume Up',
      );
    }

    if (lower.contains('volume down') || lower.contains('decrease volume') || lower.contains('quieter')) {
      return VoiceParserResult(
        command: RemoteCommand.VOLUME_DOWN,
        text: spokenText,
        isSupported: true,
        message: 'Executing Volume Down',
      );
    }

    if (lower.contains('mute') || lower.contains('silence')) {
      return VoiceParserResult(
        command: RemoteCommand.MUTE,
        text: spokenText,
        isSupported: true,
        message: 'Executing Mute',
      );
    }

    if (lower.contains('power off') || lower.contains('turn off tv') || lower.contains('turn off')) {
      return VoiceParserResult(
        command: RemoteCommand.POWER_OFF,
        text: spokenText,
        isSupported: true,
        message: 'Executing Power Off',
      );
    }

    if (lower.contains('power on') || lower.contains('turn on tv')) {
      return VoiceParserResult(
        command: RemoteCommand.POWER_ON,
        text: spokenText,
        isSupported: true,
        message: 'Executing Power On',
      );
    }

    if (lower.contains('home') || lower.contains('go home')) {
      return VoiceParserResult(
        command: RemoteCommand.HOME,
        text: spokenText,
        isSupported: true,
        message: 'Navigating to Home',
      );
    }

    if (lower.contains('back') || lower.contains('go back')) {
      return VoiceParserResult(
        command: RemoteCommand.BACK,
        text: spokenText,
        isSupported: true,
        message: 'Executing Back',
      );
    }

    if (lower.contains('pause')) {
      return VoiceParserResult(
        command: RemoteCommand.PAUSE,
        text: spokenText,
        isSupported: true,
        message: 'Pausing Media',
      );
    }

    if (lower.contains('play')) {
      return VoiceParserResult(
        command: RemoteCommand.PLAY,
        text: spokenText,
        isSupported: true,
        message: 'Playing Media',
      );
    }

    return VoiceParserResult(
      command: null,
      text: spokenText,
      isSupported: false,
      message: 'This TV does not currently support that command.',
    );
  }
}
