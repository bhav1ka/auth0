import 'package:mpsc_demo/utils/preferences.dart';
import 'package:flutter/material.dart';

/// Notifier for changes to the global app state.
class AppStateNotifier extends ChangeNotifier {
  /// Whether dark mode is currently enabled.
  bool _isDarkMode = Preferences().isDarkMode;

  /// Enable or disable dark mode.
  set darkModeEnabled(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    Preferences().isDarkMode = isDarkMode;
    notifyListeners();
  }

  /// Check whether dark mode is enabled.
  bool get darkModeEnabled {
    return _isDarkMode;
  }
}
