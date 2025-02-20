import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:puc_app/core/utilities/logs.dart';
import 'package:puc_app/providers/utility_provider_provider.dart';

import '../screens/purchase/success_screen.dart';

class StatusWatchProvider extends ChangeNotifier {
  String _paymentStatus = "pending";
  Timer? _timer;

  String get paymentStatus => _paymentStatus;
  final Dio _dio = Dio();

  /// Function to check payment status
  Future<void> checkPaymentStatus(String transactionId, BuildContext context) async {
    final utilityProvider = Provider.of<UtilityProviderProvider>(context, listen: false);
    final provider = utilityProvider.selectedUtilityProvider;

    if (provider == null) return;

    try {
      final response = await _dio.post(
        "${provider.endpoint}/purchase/status",
        data: {"transaction_id": transactionId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        _paymentStatus = data['status'];
        notifyListeners();

        if (_paymentStatus == "completed") {
          stopPolling();


          DevLogs.logInfo("PAYMENT COMPLETED");

          //Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessScreen(transaction: null,)));
        } else if (_paymentStatus == "cancelled" || _paymentStatus == "abandoned") {
          stopPolling();

          DevLogs.logWarning("PAYMENT CANCELLED");

          //Navigator.pushReplacementNamed(context, '/failure');
        }
      }
    } catch (e) {
      print("Error fetching payment status: $e");
    }
  }

  /// Start polling every 5 seconds
  void startPolling(String transactionId, BuildContext context) {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      DevLogs.logWarning('POLL RESTARTED');
      checkPaymentStatus(transactionId, context);
    });
  }

  /// Stop polling
  void stopPolling() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}
