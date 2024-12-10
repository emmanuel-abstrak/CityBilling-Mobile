import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/animations/slide_transition_dialog.dart';
import 'package:utility_token_app/features/buy/models/meter_details.dart';
import 'package:utility_token_app/features/buy/state/payment_controller.dart';
import 'package:utility_token_app/features/property/state/property_controller.dart';
import 'package:utility_token_app/widgets/dropdown/custom_dropdown.dart';
import '../../../core/constants/color_constants.dart';
import '../../../widgets/dialogs/payment_summary.dart';
import '../../../widgets/custom_button/general_button.dart';
import '../../../widgets/text_fields/custom_text_field.dart';
import '../helper/helper.dart';

class BuyUtilityScreen extends StatefulWidget {
  final MeterDetails? selectedProperty;

  const BuyUtilityScreen({super.key, this.selectedProperty});

  @override
  State<BuyUtilityScreen> createState() => _BuyUtilityScreenState();
}

class _BuyUtilityScreenState extends State<BuyUtilityScreen> {
  final PaymentController paymentController = Get.find<PaymentController>();
  final PropertyController propertyController = Get.find<PropertyController>();
  final _amountController = TextEditingController();
  late TextEditingController _meterNumberTextEditingController;
  String selectedCurrency = 'USD';
  List<MeterDetails> cachedProperties = [];

  @override
  void initState() {
    super.initState();
    cachedProperties = propertyController.properties;
    _meterNumberTextEditingController = TextEditingController(
      text: widget.selectedProperty?.number ?? '',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: const Icon(
                  FontAwesomeIcons.chevronLeft,
                  size: 20,
                ),
              ),
            );
          },
        ),
        title: const Text('Buy Utility Tokens'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Autocomplete<MeterDetails>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty)
                  return const Iterable<MeterDetails>.empty();

                return cachedProperties.where((property) {
                  final customerName =
                      property.customerName.toLowerCase() ?? '';
                  final meterNumber = property.number.toLowerCase() ?? '';
                  final query = textEditingValue.text.toLowerCase();
                  return customerName.contains(query) ||
                      meterNumber.contains(query);
                });
              },
              displayStringForOption: (MeterDetails property) =>
                  '${property.customerName} - ${property.number}',
              onSelected: (MeterDetails selection) {
                _meterNumberTextEditingController.text = selection.number ?? '';
                FocusScope.of(context).unfocus(); // Close the keyboard
              },
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                _meterNumberTextEditingController = textEditingController;
                if (widget.selectedProperty != null &&
                    textEditingController.text.isEmpty) {
                  textEditingController.text = widget.selectedProperty!.number;
                }
                return CustomTextField(
                  prefixIcon: const Icon(FontAwesomeIcons.gaugeHigh),
                  controller: textEditingController,
                  labelText: 'Meter Number',
                  focusNode: focusNode,
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                  onTapOutSide: (event) {
                    FocusScope.of(context).unfocus();
                  },
                );
              },
              optionsViewBuilder: (
                BuildContext context,
                AutocompleteOnSelected<MeterDetails> onSelected,
                Iterable<MeterDetails> options,
              ) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(8.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 200,
                        maxWidth: 300, // You can adjust this for alignment
                      ),
                      child: ListView.separated(
                        itemCount: options.length,
                        separatorBuilder: (_, __) =>
                            Divider(color: Colors.grey.shade300),
                        itemBuilder: (BuildContext context, int index) {
                          final MeterDetails option = options.elementAt(index);
                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            leading: const Icon(FontAwesomeIcons.gaugeHigh),
                            title: Text(
                              option.customerName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            subtitle: Text(
                              option.number,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              onSelected(option); // Handle option selection
                              FocusScope.of(context)
                                  .unfocus(); // Close the keyboard
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              prefixIcon: const Icon(FontAwesomeIcons.moneyBill),
              controller: _amountController,
              labelText: 'Amount',
              keyboardType: TextInputType.number,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GeneralButton(
                    onTap: () async {
                      bool detailsValid =
                          await PaymentHelper.validatePaymentDetails(
                        meterNumber: _meterNumberTextEditingController.text,
                        amount: _amountController.text,
                        selectedCurrency: selectedCurrency,
                      );

                      if (detailsValid) {
                        Get.dialog(
                            barrierDismissible: false,
                            SlideTransitionDialog(
                              child: PurchaseSummaryDialog(
                                paymentController: paymentController,
                                onClose: () {
                                  Get.back();
                                },
                              ),
                            ));
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
            )
          ],
        ),
      ),
    );
  }
}
