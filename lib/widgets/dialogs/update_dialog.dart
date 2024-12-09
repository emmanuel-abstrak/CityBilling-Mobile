import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/icon_asset_constants.dart';
import '../custom_button/general_button.dart';
import '../snackbar/custom_snackbar.dart';
import '../text_fields/custom_text_field.dart';

class UpdateDialog extends StatefulWidget {
  final String title;
  final String initialValue;
  final ValueChanged<String> onUpdate;

  const UpdateDialog({
    super.key,
    required this.title,
    required this.initialValue,
    required this.onUpdate,
  });

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  late TextEditingController controller;

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
      backgroundColor: Colors.transparent,
      child: Container(
        height: 350,
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

            SvgPicture.asset(
              CustomIcons.meter,
              semanticsLabel: 'meter',
              color: Pallete.primary,
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Update ${widget.title}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 16,
            ),

            CustomTextField(
              prefixIcon: const Icon(Icons.location_city),
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
                    btnColor: Colors.grey.shade300,
                    child: const Icon(
                        Icons.close
                    )
                ),
                const SizedBox(
                  width: 16,
                ),
                GeneralButton(
                  onTap: () {
                    final value = controller.text;
                    if((value.isNotEmpty && value.length >= 8)){
                      Get.back();
                      widget.onUpdate(controller.text.trim());
                    }else{
                      CustomSnackBar.showErrorSnackbar(message: 'Meter Number number must have at least 8 digits');
                    }
                  },
                  width: 200,
                  btnColor: Pallete.primary,
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
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
