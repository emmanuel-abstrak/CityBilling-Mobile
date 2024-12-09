import 'dart:convert';

import 'package:utility_token_app/core/constants/url_constants.dart';
import 'package:utility_token_app/core/utils/api_response.dart';
import 'package:utility_token_app/core/utils/logs.dart';
import 'package:http/http.dart' as http;
import 'package:utility_token_app/features/buy/models/purchase_summary.dart';

class PaymentServices {
  static Future<APIResponse<PurchaseSummary>> lookUpCustomerDetails({
    required String accessToken,
    required String meterNumber,
    required String currency,
    required double amount,
  }) async {
    const String url = "${UrlConstants.paymentsBaseUrl}/vending/meter-lookup";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'Application/json',
        },
        body: jsonEncode({
          'meter': meterNumber,
          'currency': currency,
          'amount': amount.toString(),
        }),
      );

      if (response.statusCode == 200) {
        DevLogs.logSuccess(response.body);

        final data = jsonDecode(response.body)['result'];

        final summary = PurchaseSummary.fromJson(data);

        return APIResponse(
          success: true,
          message: 'Customer details fetched successfully',
          data: summary,
        );
      } else {
        DevLogs.logError(response.body);
        return APIResponse(
          success: false,
          message: 'Unauthorized',
        );
      }
    } catch (e, stacktrace) {
      DevLogs.logError("Error: $e, Stacktrace: $stacktrace");
      return APIResponse(
        success: false,
        message: e.toString(),
      );
    }
  }


  static Future<APIResponse<String>> initiatePayment({
    required String accessToken,
    required String meterNumber,
    required String currency,
    required double amount,
  }) async {
    const String url = "${UrlConstants.paymentsBaseUrl}/vending/buy";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'Application/json',
        },
        body: jsonEncode({
          'meter': meterNumber,
          'currency': currency,
          'amount': amount.toString(),
        }),
      );

      if (response.statusCode == 200) {
        DevLogs.logSuccess(response.body);

        final data = jsonDecode(response.body)['result'];

        final String redirectUrl = data['redirect_url'];

        return APIResponse(
          success: true,
          message: 'Payment Initiated Successfully',
          data: redirectUrl,
        );
      } else {
        DevLogs.logError(response.body);
        return APIResponse(
          success: false,
          message: 'Payment confirmation failed. Please try again!',
        );
      }
    } catch (e, stacktrace) {
      DevLogs.logError("Error: $e, Stacktrace: $stacktrace");
      return APIResponse(
        success: false,
        message: e.toString(),
      );
    }
  }



  static Future<APIResponse<String>> getPurchaseDetails({
    required int purchaseId,
    required String accessToken
  }) async {
    final String url = "${UrlConstants.paymentsBaseUrl}vending/water-purchases/$purchaseId";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'Application/json',
        },
      );

      if (response.statusCode == 200) {
        DevLogs.logSuccess(response.body);

        final data = jsonDecode(response.body)['result'];

        final String redirectUrl = data['redirect_url'];

        return APIResponse(
          success: true,
          message: 'Payment Initiated Successfully',
          data: redirectUrl,
        );
      } else {
        DevLogs.logError(response.body);
        return APIResponse(
          success: false,
          message: 'Payment confirmation failed. Please try again!',
        );
      }
    } catch (e, stacktrace) {
      DevLogs.logError("Error: $e, Stacktrace: $stacktrace");
      return APIResponse(
        success: false,
        message: e.toString(),
      );
    }
  }
}
