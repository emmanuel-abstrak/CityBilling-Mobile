import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/core/utils/dimensions.dart';
import 'package:utility_token_app/features/buy/models/purchase_summary.dart';
import 'package:utility_token_app/features/buy/state/payment_controller.dart';
import '../../core/constants/color_constants.dart';
import '../circular_loader/circular_loader.dart';
import '../custom_button/general_button.dart';

class PurchaseSummaryBottomSheet extends StatelessWidget {
  final VoidCallback onClose;
  final PaymentController paymentController;

  const PurchaseSummaryBottomSheet({super.key,
    required this.onClose,
    required this.paymentController,
  });

  @override
  Widget build(BuildContext context) {
    final PurchaseSummary summary = paymentController.purchaseSummary.value!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Purchase Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Pallete.primary,
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, color: Colors.black54),
              ),
            ],
          ),
          const Divider(color: Colors.grey, height: 20),

          // Customer Info
          _buildInfoRow('Customer:', summary.meter.customerName),
          _buildInfoRow('Meter Number:', summary.meter.number),
          _buildInfoRow('Amount To Pay:', '\$${summary.amount.toStringAsFixed(2)}'),
          _buildInfoRow('Token Amount:', '\$${summary.tokenAmount.toStringAsFixed(2)}'),

          const SizedBox(height: 20),

          // Confirm Payment Button
          Row(
            children: [
              Expanded(
                child: GeneralButton(
                  onTap: () async {
                    Get.dialog(
                      barrierDismissible: false,
                      const CustomLoader(message: 'Redirecting...'),
                    );
                    await paymentController.initiatePayment(
                      accessToken: 'your-access-token', // Use the correct token
                      meterNumber: summary.meter.number,
                      currency: summary.currency,
                      amount: summary.amount,
                    ).then((_) {
                      onClose();
                    });
                  },
                  btnColor: Pallete.primary,
                  width: Dimensions.screenWidth,
                  child: const Text(
                    'Confirm Payment',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Custom Method to Build Info Rows
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
