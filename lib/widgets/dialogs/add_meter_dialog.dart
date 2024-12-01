import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/widgets/snackbar/custom_snackbar.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/dimensions.dart';
import '../../features/property/helper/property_helper.dart';
import '../../features/property/state/meter_number_controller.dart';
import '../custom_button/general_button.dart';
import '../text_fields/custom_text_field.dart';

class AddMeterDialog extends StatefulWidget {
  final String title;
  final String initialValue;

  const AddMeterDialog({
    super.key,
    required this.title,
    required this.initialValue,
  });

  @override
  State<AddMeterDialog> createState() => _AddMeterDialogState();
}

class _AddMeterDialogState extends State<AddMeterDialog> {
  late TextEditingController controller;
  final MeterNumberController meterStateNumberController = Get.find<MeterNumberController>();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    final isButtonDisabled = controller.text.length < 5 || widget.initialValue == controller.text;

    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 200,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Save ${widget.title}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            CustomTextField(
              prefixIcon: const Icon(FontAwesomeIcons.gaugeHigh),
              labelText: widget.title,
              controller: controller,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(
              height: 16,
            ),
            GeneralButton(
              onTap: isButtonDisabled  ? null  : () async{
                Get.back();
                final value = controller.text;
                if (value.isNotEmpty) {
                  bool detailsValid = await PropertyHelper.lookUpDetails(
                    meterNumber: value,
                  );
                  if(detailsValid){
                    meterStateNumberController.addMeterNumber(value);
                  }
                }
              },
              width: Dimensions.screenWidth,
              btnColor: isButtonDisabled ? Colors.grey : Pallete.primary,
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
