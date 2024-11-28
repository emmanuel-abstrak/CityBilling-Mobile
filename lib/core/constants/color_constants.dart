import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Pallete{
 static const Color primary = Color(0xFF1E88E5);
 static const Color secondary = Color(0xFF26A69A);
 static const Color background = Color(0xFFF5F5F5);
 static const Color surface = Colors.white;
 static var success = Colors.green[600];
 static const Color error = Color(0xFFD32F2F);
 static const Color onPrimary = Colors.white;
 static const Color onSecondary = Colors.white;
 static const Color onBackground = Colors.black87;
 static const Color onSurface = Colors.black87;
 static const Color onError = Colors.white;
 static const Color onSuccess = Colors.white;


 static ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  scaffoldBackgroundColor: surface,
  appBarTheme: const AppBarTheme(
   elevation: 0,
   iconTheme: IconThemeData(color: Colors.white),
   centerTitle: true,

   backgroundColor: primary,
   systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: surface,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.light,
   ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
   style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Colors.blue,
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
    borderSide: const BorderSide(color: Colors.blue, width: 2),
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