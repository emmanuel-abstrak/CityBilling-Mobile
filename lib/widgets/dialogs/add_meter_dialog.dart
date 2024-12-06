import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/features/property/state/property_controller.dart';
import 'package:utility_token_app/widgets/snackbar/custom_snackbar.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/icon_asset_constants.dart';
import '../circular_loader/circular_loader.dart';
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
  final PropertyController propertyController = Get.find<PropertyController>();

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
        height: 400,
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 4),
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
                Column(
                  children: [
                    SvgPicture.asset(
                      CustomIcons.meter,
                      semanticsLabel: 'meter',
                      color: Pallete.primary,
                      height: 100,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Save ${widget.title}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GeneralButton(
                  onTap: (){
                    Get.back();
                  },
                  width: 60,
                  btnColor: Colors.grey,
                  child: SvgPicture.asset(
                    CustomIcons.back,
                    semanticsLabel: 'meter',
                    color: Pallete.surface,
                    height: 20,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                GeneralButton(
                  onTap: isButtonDisabled  ? null  : () async{
                    Get.back();
                    final value = controller.text;
                    if (value.isNotEmpty) {


                     Get.showOverlay(
                       asyncFunction: () async {
                         await propertyController.lookUpProperty(
                           meterNumber: value,
                         ).then((response){
                           if(response.success == true){
                             propertyController.addProperty(response.data.meter);
                             CustomSnackBar.showSuccessSnackbar(message: 'Property Added Successfully');
                           }else{
                             CustomSnackBar.showErrorSnackbar(duration: 8,message:'Failed to add property, check your Meter Number and try again');
                           }
                         });
                       },
                       loadingWidget: const Center(
                         child: CustomLoader(
                           message: 'Checking meter number...',
                         ),
                       ),
                     );

                    }
                  },
                  width: 200,
                  btnColor: isButtonDisabled ? Colors.grey : Pallete.primary,
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
