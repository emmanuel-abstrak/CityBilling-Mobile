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
import '../../property/state/meter_number_controller.dart';
import '../helper/helper.dart';

class BuyUtilityScreen extends StatefulWidget {
  final Municipality municipality;
  final String? selectedMeterNumber;

  const BuyUtilityScreen({super.key,required this.municipality, this.selectedMeterNumber});

  @override
  State<BuyUtilityScreen> createState() => _BuyUtilityScreenState();
}

class _BuyUtilityScreenState extends State<BuyUtilityScreen> {
  final PaymentController paymentController = Get.find<PaymentController>();
  final MeterNumberController meterStateNumberController = Get.find<MeterNumberController>();
  final _amountController = TextEditingController();
  TextEditingController _meterNumberTextEditingController = TextEditingController();
  String selectedCurrency = 'USD';
  final RxBool showBottomSheet = false.obs;
  List<String> cachedMeterNumber = [];

  @override
  void initState() {
    super.initState();
    cachedMeterNumber = meterStateNumberController.meterNumbers;
    if (widget.selectedMeterNumber != null) {
      _meterNumberTextEditingController = TextEditingController(
        text: widget.selectedMeterNumber
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return cachedMeterNumber.where((String option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                _meterNumberTextEditingController.text = selection;
              },
              fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted,
                  ) {
                _meterNumberTextEditingController = textEditingController;
                return CustomTextField(
                  prefixIcon: const Icon(FontAwesomeIcons.gaugeHigh),
                  controller: textEditingController,
                  labelText: 'Meter Number',
                  focusNode: focusNode,
                );
              },

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
                        meterNumber: _meterNumberTextEditingController.text,
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
