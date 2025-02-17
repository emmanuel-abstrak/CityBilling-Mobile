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
      double amount, String currencyCode) async {
    final utilityProvider =
        Provider.of<UtilityProviderProvider>(context, listen: false)
            .selectedUtilityProvider;

    if (utilityProvider == null) {
      DevLogs.logError("No Utility Provider selected.");
      return;
    }

    final String apiUrl = "${utilityProvider.endpoint}/purchase/lookup";

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.post(
          apiUrl,
          data: {
            "meter": meterNumber,
            "amount": amount,
            "currency": currencyCode
          }
      );

      DevLogs.logInfo("Raw Response: ${response.toString()}");

      final responseData = response.data;

      if (response.statusCode == 201) {
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('data')) {
            final data = responseData['data'];
            DevLogs.logInfo("Response Data: $data");
            _isLoading = false;
            notifyListeners();
            return data;
          } else {
            DevLogs.logInfo("Returning full response as fallback.");
            _isLoading = false;
            notifyListeners();
            return responseData; // Return full response instead of throwing an error
          }
        } else {
          _error = "Unexpected response format. Expected Map<String, dynamic>, got: ${responseData.runtimeType}";
          DevLogs.logError(_error);
        }
      } else {
        _error = responseData is Map<String, dynamic> && responseData.containsKey('message')
            ? responseData['message']
            : "Unknown error occurred";

        DevLogs.logError("Error Message: $_error");
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          DevLogs.logInfo("Raw Error Response: ${e.response?.data}");
          DevLogs.logInfo("Error Response Type: ${e.response?.data.runtimeType}");

          final errorResponse = e.response?.data;
          _error = errorResponse is Map<String, dynamic> && errorResponse.containsKey('message')
              ? errorResponse['message']
              : "Unexpected error response format";

          DevLogs.logError("DioException: $_error");
        } else {
          _error = e.error.toString();
          DevLogs.logError("DioException (No Response): $_error");
        }
      } else {
        _error = e.toString();
        DevLogs.logError("Unexpected Error: $_error");
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
