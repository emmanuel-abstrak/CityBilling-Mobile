import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:puc_app/core/constants/icon_asset_constants.dart';

import '../../../animations/slide_transition_dialog.dart';
import '../../../core/constants/color_constants.dart';
import '../../../widgets/custom_button/general_button.dart';
import '../../../widgets/dialogs/payment_summary.dart';
import '../../../widgets/dropdown/custom_dropdown.dart';
import '../../../widgets/text_fields/custom_text_field.dart';
import '../../buy/helper/helper.dart';
import '../../buy/models/meter_details.dart';
import '../../buy/state/payment_controller.dart';
import '../../property/state/property_controller.dart';

class BuyScreen extends StatefulWidget {
  final String title = "Purchase history";
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  final PropertyController propertyController = Get.find<PropertyController>();
  final PaymentController paymentController = Get.find<PaymentController>();
  final _amountController = TextEditingController();
  late TextEditingController _meterNumberTextEditingController;
  String selectedCurrency = 'USD';
  List<MeterDetails> cachedProperties = [];

  @override
  void initState() {
    super.initState();
    cachedProperties = propertyController.properties;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Autocomplete<MeterDetails>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<MeterDetails>.empty();
              }
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

              return CustomTextField(
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
                    constraints: BoxConstraints(
                      maxHeight: options.length * 80 + 18,
                      maxWidth: MediaQuery.sizeOf(context).width - 32, // You can adjust this for alignment
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
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Pallete.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: SvgPicture.asset(
                              CustomIcons.meter,
                              semanticsLabel: 'view property',
                              height: 20,
                            ),
                          ),
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
            controller: _amountController,
            labelText: 'Amount',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomDropDown(
            items: const ['USD', 'ZWG'],
            selectedValue: selectedCurrency,
            prefix: SvgPicture.asset(CustomIcons.dollar),
            onChanged: (value) {
              setState(() {
                selectedCurrency = value!;
              });
            },
            isEnabled: true,
          ),
          const SizedBox(height: 20),
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
                  btnColor: Pallete.orange,
                  child: Text(
                    ('Continue').toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
