import 'package:flutter/material.dart';
import 'package:utility_token_app/core/utils/dimensions.dart';
import 'package:utility_token_app/widgets/snackbar/custom_snackbar.dart';

import '../../core/constants/color_constants.dart';
import '../../features/municipalities/models/municipality.dart';
import '../custom_button/general_button.dart';

class PurchaseSummaryBottomSheet extends StatelessWidget {
  final Municipality municipality;
  final String meterNumber;
  final String amount;
  final String currency;
  final VoidCallback onClose;

  const PurchaseSummaryBottomSheet({super.key,
    required this.municipality,
    required this.meterNumber,
    required this.amount,
    required this.currency,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Purchase Summary',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const Divider(),
          Text('Municipality: ${municipality.name}'),
          const SizedBox(height: 8),
          Text('Meter Number: $meterNumber'),
          const SizedBox(height: 8),
          Text('Amount: $amount $currency'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GeneralButton(
                  onTap: () {
                    onClose();
                    CustomSnackBar.showSuccessSnackbar(message: 'Your payment has been successfully initiated.');
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
        ],
      ),
    );
  }
}
