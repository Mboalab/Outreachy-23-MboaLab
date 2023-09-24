import 'package:flutter/material.dart';

/// Defines shared theme constants used by light and dark themes

/// Primary theme colors
const Color primaryColor = Color(0xff3D79FD);

/// Secondary variant of primary color for dark themes
const Color primaryVariant = Color(0xff2a56c6);

/// Color for text/icons on top of primary colors
const Color onPrimary = Colors.white;

/// Color for error messages
const Color errorColor = Color(0xffe53935);

/// Background color for light themes
const Color scaffoldBackgroundLight = Colors.white;

/// Background color for dark themes
const Color scaffoldBackgroundDark = Color(0xff1E1E1E);

/// Shared text theme styles
const TextStyle headlineLarge =
    TextStyle(fontSize: 40, fontWeight: FontWeight.bold);
const TextStyle headlineMedium =
    TextStyle(fontSize: 30, fontWeight: FontWeight.w500);
const TextStyle headlineSmall =
    TextStyle(fontSize: 24, fontWeight: FontWeight.w500);

/// Border radius used for cards
const BorderRadius cardRadius = BorderRadius.all(Radius.circular(8));
