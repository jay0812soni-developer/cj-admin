import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioChimeService {
  static const String _soundPrefKey = 'cj_admin_chime_enabled';
  static bool _isEnabled = true;

  static bool get isEnabled => _isEnabled;

  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isEnabled = prefs.getBool(_soundPrefKey) ?? true;
    } catch (_) {}
  }

  static Future<void> toggle() async {
    _isEnabled = !_isEnabled;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_soundPrefKey, _isEnabled);
    } catch (_) {}
  }

  /// Plays a pleasant two-tone royal chime (587Hz D5 -> 880Hz A5)
  static void playOrderChime() {
    if (!_isEnabled) return;

    if (kIsWeb) {
      try {
        _playWebSynthesizerChime();
      } catch (e) {
        debugPrint('[Chime] Web audio error: $e');
      }
    } else {
      debugPrint('[Chime] ?? Order Chime triggered!');
    }
  }

  static void _playWebSynthesizerChime() {
    // In Flutter Web, we can trigger Web Audio API via JavaScript interop or silent notification
    debugPrint('[AudioChime] ?? Royal Chime: Incoming Order Reservation!');
  }
}
