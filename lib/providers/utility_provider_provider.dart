import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:puc_app/configs/api_configs.dart';
import 'package:puc_app/core/utilities/logs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/utility_provider.dart';

class UtilityProviderProvider extends ChangeNotifier {
  List<UtilityProvider> _providers = [];
  List<UtilityProvider> _filteredProviders = [];
  UtilityProvider? _selectedUtilityProvider;
  bool _isLoading = true;

  List<UtilityProvider> get providers => _filteredProviders;
  UtilityProvider? get selectedUtilityProvider => _selectedUtilityProvider;
  bool get isLoading => _isLoading;

  final Dio _dio = Dio();

  /// Constructor: Load selected municipality on startup
  UtilityProviderProvider() {
    _loadSelectedUtilityProvider();
  }

  /// Fetch providers from API
  Future<void> fetchProviders() async {
    try {
      final response = await _dio.get("${APIConfigs.baseUrl}/providers");

      final data = response.data;

      DevLogs.logInfo("Fetched ${data} providers");


      _providers = (data['data'] as List)
          .map((json) => UtilityProvider.fromJson(json))
          .toList();

      _filteredProviders = _providers;
      notifyListeners();
    } catch (e) {
      DevLogs.logError("Error fetching providers: $e");
    }
  }

  /// Filter providers based on search query
  void filterProviders(String query) {
    if (query.isEmpty) {
      _filteredProviders = _providers;
    } else {
      _filteredProviders = _providers
          .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  /// Set selected municipality and save to SharedPreferences
  Future<void> selectUtilityProvider(UtilityProvider municipality) async {
    _selectedUtilityProvider = municipality;
    notifyListeners();
    await _saveSelectedUtilityProvider();
  }

  /// Save selected municipality to SharedPreferences
  Future<void> _saveSelectedUtilityProvider() async {
    if (_selectedUtilityProvider != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'selected_municipality_id', _selectedUtilityProvider!.id);
      await prefs.setString(
          'selected_municipality_name', _selectedUtilityProvider!.name);
      await prefs.setString(
          'selected_municipality_endpoint', _selectedUtilityProvider!.endpoint);
    }
  }

  /// Load selected municipality from SharedPreferences
  Future<void> _loadSelectedUtilityProvider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('selected_municipality_id');
    String? name = prefs.getString('selected_municipality_name');
    String? endpoint = prefs.getString('selected_municipality_endpoint');

    if (id != null && name != null && endpoint != null) {
      _selectedUtilityProvider =
          UtilityProvider(id: id, name: name, endpoint: endpoint);
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Clear selected municipality and reset state
  Future<void> clearSelectedUtilityProvider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_municipality_id');
    await prefs.remove('selected_municipality_name');
    await prefs.remove('selected_municipality_endpoint');

    _selectedUtilityProvider = null;
    notifyListeners();
  }
}
