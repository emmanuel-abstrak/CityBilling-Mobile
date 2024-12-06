import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/features/buy/helper/helper.dart';
import 'package:utility_token_app/features/buy/models/purchase_summary.dart';
import 'package:utility_token_app/features/buy/state/payment_controller.dart';
import '../../config/routes/router.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/icon_asset_constants.dart';
import '../circular_loader/circular_loader.dart';
import '../custom_button/general_button.dart';
import '../snackbar/custom_snackbar.dart';

class PurchaseSummaryDialog extends StatelessWidget {
  final VoidCallback onClose;
  final PaymentController paymentController;

  const PurchaseSummaryDialog({
    super.key,
    required this.onClose,
    required this.paymentController,
  });

  @override
  Widget build(BuildContext context) {
    final PurchaseSummary summary = paymentController.purchaseSummary.value!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        alignment: Alignment.bottomCenter,
        insetPadding: EdgeInsets.zero,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(flex: 3, child: Container()),
                    const Expanded(
                      flex: 1,
                      child: Divider(
                        thickness: 5,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(flex: 3, child: Container()),
                  ],
                ),
                SvgPicture.asset(
                  CustomIcons.confirmPayment,
                  //colorFilter: ColorFilter.mode(Colors.red, BlendMode.clear),
                  semanticsLabel: 'confrim payment',
                  height: 200,
                ),
                Text(
                  'Confirm Payment',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                // Customer Info
                _buildInfoRow('Customer:', summary.meter.customerName),
                _buildInfoRow('Meter Number:', summary.meter.number),
                _buildInfoRow('Amount To Pay:', '\$${summary.amount.toStringAsFixed(2)}'),
                if (summary.balances.isNotEmpty)
                  ...summary.balances.map(
                        (balance) {
                      if (balance.amount > 0) {
                        return _buildInfoRow(
                          balance.name,
                          '\$${balance.amount.toStringAsFixed(2)}',
                          isBalance: true, // Highlight in red for balance
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                _buildInfoRow('Token Amount:', '\$${summary.tokenAmount.toStringAsFixed(2)}'),

                const SizedBox(height: 20),

                // Confirm Payment Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GeneralButton(
                      onTap: onClose,
                      btnColor: Colors.grey,
                      width: 60,
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    GeneralButton(
                      onTap: () async {
                        Get.showOverlay(
                          asyncFunction: () async {
                            await paymentController.initiatePayment(
                              accessToken: 'w7BKImq5uMapLoURhh2cypPv5rdwZy7ExJ968kresYmYCUk2amez784imVgNc0MA0tWxPeftYnotItIcm9eHzdZcLwkhFeedsK7SO7MbyKizrdbXVjzoVKGxGQQmx45mt5hFoQCxctp5D8oJ5WRdXzDgo3OVet1DotsuJdan8YT7aPTkjNTLgmPy6i4vAX1Zj7cSIsiAXiYQWB5mzxfJ7moxICNkfRjRf8q9jimkMd0fnJZF',
                              meterNumber: summary.meter.number,
                              currency: summary.currency,
                              amount: summary.amount,
                            ).then((response){
                              if(response.success){
                                Get.toNamed(RoutesHelper.webviewPaymentPage, arguments: response.data);
                              }else{
                                CustomSnackBar.showErrorSnackbar(duration: 8,message: response.message ?? '');
                              }
                            });
                          },
                          loadingWidget: const Center(
                            child: CustomLoader(
                              message: 'Checking meter number...',
                            ),
                          ),
                        );
                      },
                      btnColor: Pallete.primary,
                      width: 200,
                      child: const Text(
                        'Confirm Payment',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom Method to Build Info Rows
  Widget _buildInfoRow(String title, String value, {bool isBalance = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            PaymentHelper.capitalizeFirstLetter(title),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isBalance ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
