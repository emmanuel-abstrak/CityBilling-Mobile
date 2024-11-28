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
          Text(summary.meter.customerName),
          const SizedBox(height: 8),
          Text('Meter Number: ${summary.meter.number}'),
          const SizedBox(height: 8),
          Text('Amount To Pay: ${summary.amount.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          Text('Token Amount: ${summary.tokenAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GeneralButton(
                  onTap: () async{

                    Get.dialog(
                      barrierDismissible: false,
                      const CustomLoader(message: 'Redirecting...'),
                    );

                    await paymentController.initiatePayment(
                      accessToken: 'k6gX6nDH1ZuDvv0UOP41advUWhvRN0OzL7HR6q1Yop4VbVJT9vvTEyDBo6oHukey2AVSP8tZLS5FpP3gtQnCmyYDCReDyKSji2GDysnIfouTR2zRgeBVV6MSWgPzgd9su22OS2Z9fkxRt7Lzx0rOgPpk9BytVAiHDSdlrYMhYTAujaCf0uYS3Ffbg6klvf1KBsNmjPOhVPmzXMNXcGqq6vi52HHxzsyKGp21arz9ywXwkfaQ',
                      meterNumber: summary.meter.number,
                      currency: summary.currency,
                      amount: summary.amount
                    ).then((_){
                      onClose;
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
        ],
      ),
    );
  }
}
