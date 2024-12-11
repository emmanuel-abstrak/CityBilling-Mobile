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
    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Container(
        height: 250,
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
            const SizedBox(),
            Row(
              children: [
                Expanded(flex: 2, child: Container()),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Expanded(flex: 2, child: Container()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
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
              keyboardType: TextInputType.number,
              labelText: widget.title,
              controller: controller,
              onChanged: (_) => setState(() {}),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GeneralButton(
                  onTap: (){
                    Get.back();
                  },
                  width: 60,
                  borderRadius: 18,
                  btnColor: Colors.grey.withOpacity(0.2),
                  child: SvgPicture.asset(CustomIcons.cross, height: 26,),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(child: GeneralButton(
                  onTap: () async{
                    final value = controller.text;
                    if (value.isNotEmpty && value.length >= 8) {
                      Get.back();
                      Get.showOverlay(
                        asyncFunction: () async {
                          await propertyController.lookUpProperty(
                            meterNumber: value,
                          ).then((response) async{
                            if(response.success == true){
                              await propertyController.addNonExistantProperty(response.data.meter).then((exists){
                                if(exists == true){
                                  CustomSnackBar.showErrorSnackbar(message: 'Meter already exists');
                                }


                                if(exists == false){
                                  CustomSnackBar.showSuccessSnackbar(message: 'Meter added successfully');
                                }
                              });
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
                    }else{
                      CustomSnackBar.showErrorSnackbar(message: 'Invalid meter number');
                    }
                  },
                  width: 200,
                  btnColor: Pallete.orange,
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
