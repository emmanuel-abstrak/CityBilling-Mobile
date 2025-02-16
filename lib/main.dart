import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/providers/currency_provider.dart';
import 'package:mobile/providers/meter_provider.dart';
import 'package:mobile/providers/purchase_provider.dart';
import 'package:mobile/providers/transaction_provider.dart';
import 'package:mobile/screens/meter/meters_screen.dart';
import 'package:mobile/screens/purchase/purchase_screen.dart';
import 'package:mobile/screens/settings_screen.dart';
import 'package:mobile/theme/app_theme.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'providers/utility_provider_provider.dart';
import 'screens/home_screen.dart';
import 'screens/provider_selection_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UtilityProviderProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MeterProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (context) => CurrencyProvider()),
        ChangeNotifierProvider(create: (context) => PurchaseProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          _updateSystemUI(themeProvider);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Utility Token App',
            theme: themeProvider.isDarkMode
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            routes: {
              "/home": (context) => HomeScreen(),
              "/purchase": (context) => PurchaseScreen(),
              "/meters": (context) => MetersScreen(),
              "/settings": (context) => SettingsScreen(),
            },
            home: municipalityRedirect(),
          );
        },
      ),
    );
  }

  Widget municipalityRedirect() {
    return Consumer<UtilityProviderProvider>(
      builder: (context, municipalityProvider, child) {
        if (municipalityProvider.isLoading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        return municipalityProvider.selectedUtilityProvider != null
            ? const HomeScreen()
            : UtilityProviderSelectionScreen();
      },
    );
  }

  /// **Update System UI Colors (Status Bar & Navigation Bar)**
  void _updateSystemUI(ThemeProvider themeProvider) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: themeProvider.isDarkMode ? AppTheme.darkBackground : AppTheme.lightBackground,
      statusBarIconBrightness: themeProvider.isDarkMode ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: themeProvider.isDarkMode ? AppTheme.darkBackground : AppTheme.lightBackground,
      systemNavigationBarIconBrightness:
          themeProvider.isDarkMode ? Brightness.light : Brightness.dark,
    ));
  }
}
