import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puc_app/widgets/custom_typography/typography.dart';

class Pallete {
  static const Color secondary = Color(0xFF0B378F);
  static const Color orange = Color(0xFFF57F00);
  static const Color primary = Color(0xFF1690ED);
  static var success = Colors.green[600];
  static const Color error = Color(0xFFD32F2F);
  static const Color scaffold = Color(0xFFF5F6FA);
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;
  static const Color onBackground = Colors.black87;
  static const Color onSurface = Colors.black87;
  static const Color onError = Colors.white;
  static const Color onSuccess = Colors.white;

  static ThemeData appTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Nunito',
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      elevation: 0,
      iconTheme: const IconThemeData(color: onSurface),
      backgroundColor: Colors.white,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      titleTextStyle: CustomTypography.nunitoTextTheme.titleMedium
          ?.copyWith(color: onSurface, fontWeight: FontWeight.bold),
    ),
    textTheme: CustomTypography.nunitoTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
