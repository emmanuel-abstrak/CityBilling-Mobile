import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mobile/providers/utility_provider_provider.dart';
import 'package:provider/provider.dart';

class CurrencyProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _currencies = [];
  Map<String, dynamic>? _selectedCurrency;
  bool _isLoading = false;

  List<Map<String, dynamic>> get currencies => _currencies;
  Map<String, dynamic>? get selectedCurrency => _selectedCurrency;
  bool get isLoading => _isLoading;

  final Dio _dio = Dio();

  /// **Fetch Currencies from the API Using the Selected UtilityProvider's Base URL**
  Future<void> fetchCurrencies(BuildContext context) async {
    final utilityProvider =
        Provider.of<UtilityProviderProvider>(context, listen: false)
            .selectedUtilityProvider;

    if (utilityProvider == null) {
      debugPrint("No Utility Provider selected.");
      return;
    }

    final String apiUrl = "${utilityProvider.endpoint}/currencies";

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.get(apiUrl);

      Logger().w(response);

      if (response.statusCode == 200) {
        _currencies = (response.data as List)
            .map((c) => {
                  "code": c["code"],
                  "symbol": c["symbol"],
                })
            .toList();
        _selectedCurrency = _currencies.first; // Default to first currency
      } else {
        debugPrint("Failed to load currencies: ${response.data}");
      }
    } catch (e) {
      debugPrint("Error fetching currencies: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// **Set Selected Currency**
  void selectCurrency(Map<String, dynamic> currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }
}
