import 'dart:math';

enum PhoneNetworkType {
  homeWifi,
  mobileData,
  noNetwork,
}

class FriendlyErrorTranslator {
  static String translate(Object error) {
    final errStr = error.toString().toLowerCase();

    if (errStr.contains('socketexception') || errStr.contains('connection refused') || errStr.contains('connection failed')) {
      return 'Unable to connect to your TV.\n\nMake sure:\n• Your phone and TV are on the same Wi-Fi network.\n• The TV is turned on.\n• The TV Remote app is running.';
    }

    if (errStr.contains('timeout')) {
      return 'Connection timed out. Check if your TV is turned on and connected to Wi-Fi.';
    }

    if (errStr.contains('unauthorized') || errStr.contains('pairing')) {
      return 'Pairing authentication failed or expired. Please pair your phone again using the 6-digit code on screen.';
    }

    return 'Unable to connect to your TV. Please check your network connection and try again.';
  }
}

class ExponentialBackoffReconnect {
  int _attempt = 0;
  final int maxAttempts = 5;

  Duration nextDelay() {
    _attempt++;
    final delaySeconds = min(pow(2, _attempt).toInt(), 16);
    return Duration(seconds: delaySeconds);
  }

  void reset() {
    _attempt = 0;
  }
}
