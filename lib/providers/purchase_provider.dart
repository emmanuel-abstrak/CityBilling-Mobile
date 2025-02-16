import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puc_app/providers/utility_provider_provider.dart';

import '../core/utilities/logs.dart';

class PurchaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _error = "";
  String get error => _error;

  final Dio _dio = Dio();


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
        final data = response.data['data'];
        DevLogs.logInfo(data);
        return data;
      } else {
        _error = response.data['message'];

        DevLogs.logError(_error);
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          _error = e.response?.data['message'];

          DevLogs.logError(_error);
        } else {
          _error = e.error.toString();

          DevLogs.logError(_error);
        }
      } else {
        _error = e.toString();

        DevLogs.logError(_error);
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
