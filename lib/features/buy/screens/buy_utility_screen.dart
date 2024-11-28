import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/features/buy/state/payment_controller.dart';
import 'package:utility_token_app/widgets/dropdown/custom_dropdown.dart';
import '../../../core/constants/color_constants.dart';
import '../../../widgets/bottom_sheet/payment_summary.dart';
import '../../../widgets/custom_button/general_button.dart';
import '../../../widgets/text_fields/custom_text_field.dart';
import '../../municipalities/models/municipality.dart';
import '../../property/state/property_controller.dart';
import '../helper/helper.dart';

class BuyUtilityScreen extends StatefulWidget {
  final Municipality? municipality;

  const BuyUtilityScreen({super.key, this.municipality});

  @override
  State<BuyUtilityScreen> createState() => _BuyUtilityScreenState();
}

class _BuyUtilityScreenState extends State<BuyUtilityScreen> {
  final PaymentController paymentController = Get.find<PaymentController>();
  final PropertyController propertyController = Get.find<PropertyController>();
  final _amountController = TextEditingController();
  TextEditingController _meterNumberController = TextEditingController();
  String selectedCurrency = 'USD';
  final RxBool showBottomSheet = false.obs;

  @override
  void initState() {
    super.initState();
    if (propertyController.property != null) {
      _meterNumberController = TextEditingController(
        text: propertyController.property!.meterNumber,
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buy Utility Tokens',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Municipality: ${widget.municipality!.name}'),
            const SizedBox(height: 16),
            CustomTextField(
              prefixIcon: const Icon(FontAwesomeIcons.gaugeHigh),
              controller: _meterNumberController,
              labelText: 'Meter Number',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              prefixIcon: const Icon(FontAwesomeIcons.moneyBill),
              controller: _amountController,
              labelText: 'Amount',
            ),
            const SizedBox(height: 16),
            CustomDropDown(
              items: const ['USD', 'ZWG'],
              selectedValue: selectedCurrency,
              prefixIcon: Icons.monetization_on_outlined,
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value!;
                });
              },
              isEnabled: true,
            ),
            const Spacer(),
            Obx(() => showBottomSheet.value
                ? const SizedBox.shrink()
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GeneralButton(
                    onTap: () async {
                      bool detailsValid = await PaymentHelper.validatePaymentDetails(
                        meterNumber: _meterNumberController.text,
                        amount: _amountController.text,
                        selectedCurrency: selectedCurrency,
                      );

                      if (detailsValid) {
                        showBottomSheet.value = true;
                      }
                    },
                    width: MediaQuery.of(context).size.width * 0.8,
                    btnColor: Pallete.primary,
                    child: const Text(
                      'Make Payment',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
      bottomSheet: Obx(
            () => showBottomSheet.value
            ? PurchaseSummaryBottomSheet(
          paymentController: paymentController,
          onClose: () => showBottomSheet.value = false,
        )
            : const SizedBox.shrink(),
      ),
    );
  }
}
