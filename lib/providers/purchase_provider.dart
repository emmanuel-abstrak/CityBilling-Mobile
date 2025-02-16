import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/providers/utility_provider_provider.dart';
import 'package:provider/provider.dart';

class PurchaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _error = "";
  String get error => _error;

  final Dio _dio = Dio();

  /// **Fetch Currencies from the API Using the Selected UtilityProvider's Base URL**
  Future<dynamic> lookup(BuildContext context, String meterNumber,
      double amount, currencyCode) async {
    final utilityProvider =
        Provider.of<UtilityProviderProvider>(context, listen: false)
            .selectedUtilityProvider;

    if (utilityProvider == null) {
      debugPrint("No Utility Provider selected.");
      return;
    }

    final String apiUrl = "${utilityProvider.endpoint}/buy/lookup";

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.post(apiUrl, data: {
        'meter': meterNumber,
        'amount': amount,
        'currency': currencyCode
      });

      if (response.statusCode == 200) {
        return response.data;
      } else {
        _error = response.data['message'];
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          _error = e.response?.data['message'];
        } else {
          _error = e.error.toString();
        }
      } else {
        _error = e.toString();
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
