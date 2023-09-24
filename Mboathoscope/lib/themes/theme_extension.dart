import 'package:flutter/material.dart';

/// Extensions on [BuildContext] to easily access theme attributes.

extension ThemeExtension on BuildContext {
  /// Get the [ThemeData] for the current context.
  ThemeData get theme => Theme.of(this);

  /// Access the [TextTheme] for the current theme.
  TextTheme get textTheme => theme.textTheme;

  /// Get the [ColorScheme] for the current theme.
  ColorScheme get colors => theme.colorScheme;

  /// Get the brightness [ThemeMode] for the current theme.
  ThemeMode get themeMode =>
      theme.brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
}
