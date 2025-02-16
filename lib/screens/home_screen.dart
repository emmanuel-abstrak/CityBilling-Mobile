import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'meter/meters_screen.dart';
import 'settings_screen.dart';
import 'token_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    TokenHistoryScreen(),
    MetersScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 10,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: themeProvider.isDarkMode ? AppTheme.darkBackground : AppTheme.lightBackground,
        elevation: 1,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
        items: [
          BottomNavigationBarItem(icon: SvgPicture.asset("assets/icons/receipt.svg", height: 24,), label: "Token History"),
          BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/icons/apps.svg", height: 24,), label: "Saved Meters"),
          BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/icons/settings.svg", height: 24,), label: "App Settings"),
        ],
      ),
    );
  }
}
