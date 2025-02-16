import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/theme_provider.dart';
import '../providers/utility_provider_provider.dart';
import '../theme/app_colors.dart';
import 'provider_selection_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  /// Load preferences from local storage
  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  /// Toggle notification preference
  Future<void> _toggleNotifications(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final utilityProviderProvider =
        Provider.of<UtilityProviderProvider>(context);
    final utilityProvider = utilityProviderProvider.selectedUtilityProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle("App Settings"),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            leading:SvgPicture.asset("assets/icons/eye.svg", color: AppColors.primaryRed,),
            title: const Text("Dark Mode"),
            trailing: Transform.scale(
              scale: .8,
              child: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(),
                activeColor: AppColors.primaryRed,
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            leading: SvgPicture.asset("assets/icons/building.svg", color: AppColors.primaryRed,),
            title: Text(utilityProvider?.name ?? "Not Selected"),
            trailing: SvgPicture.asset("assets/icons/refresh.svg"),
            onTap: () async {
              await utilityProviderProvider.clearSelectedUtilityProvider();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => UtilityProviderSelectionScreen()),
              );
            },
          ),
          const SizedBox(height: 10),
          _buildSectionTitle("Support"),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            leading: SvgPicture.asset("assets/icons/call.svg", color: AppColors.primaryRed,),
            title: const Text("Support"),
            subtitle: const Text("+263 71 456 6784"),
            onTap: () {
              // Open Support Screen or URL
            },
          ),
        ],
      ),
    );
  }

  /// Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark),
      ),
    );
  }
}
