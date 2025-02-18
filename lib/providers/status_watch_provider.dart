import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatusWatchProvider extends ChangeNotifier {
  String _paymentStatus = "pending";
  Timer? _timer;

  String get paymentStatus => _paymentStatus;

  /// Function to check payment status
  Future<void> checkPaymentStatus(String transactionId, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse("https://your-api.com/payment/status/$transactionId"),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        _paymentStatus = data['status']; // e.g., "success" or "failed"
        notifyListeners();

        if (_paymentStatus == "success") {
          stopPolling();
          Navigator.pushReplacementNamed(context, '/success'); // Navigate to success screen
        } else if (_paymentStatus == "failed") {
          stopPolling();
          Navigator.pushReplacementNamed(context, '/failure'); // Navigate to failure screen
        }
      }
    } catch (e) {
      print("Error fetching payment status: $e");
    }
  }

  /// Start polling every 5 seconds
  void startPolling(String transactionId, BuildContext context) {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
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
