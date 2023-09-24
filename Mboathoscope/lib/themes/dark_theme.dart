import 'package:flutter/material.dart';

/// Dark theme data for the app

/// Import shared constants
import 'constants.dart';

/// Dark theme data
ThemeData darkTheme = ThemeData.dark().copyWith(

    /// Use primaryColor defined in constants
    primaryColor: primaryColor,

    /// define app colorscheme with colors defined in constants

    /// TODO: define other colors such as seondary and surface colors

    colorScheme: ColorScheme.light(
      primary: primaryColor,

      // secondary: secondaryColor,

      // surface: surfaceColor,
      background: scaffoldBackgroundDark,
      error: errorColor,
      onPrimary: onPrimary,
      // onSecondary: onSecondaryColor,
      // onSurface: onSurfaceColor,
      // onBackground: onBackgroundColor,
      onError: onPrimary,
      brightness: Brightness.dark,
    ),

    /// Text themes override styles from constants
    textTheme: TextTheme(
      headlineLarge: headlineLarge.copyWith(color: onPrimary),
    ),

    /// Customize app bar theme
    appBarTheme: AppBarTheme(backgroundColor: primaryColor, elevation: 0),

    /// Card theme uses cardRadius from constants
    cardTheme:
        CardTheme(shape: RoundedRectangleBorder(borderRadius: cardRadius)));
