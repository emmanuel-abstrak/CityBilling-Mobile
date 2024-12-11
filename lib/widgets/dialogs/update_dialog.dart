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
        height: 250,
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
                  onTap: () {
                    widget.onUpdate(controller.text.trim());
                  },
                  width: 200,
                  btnColor: Pallete.orange,
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
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
