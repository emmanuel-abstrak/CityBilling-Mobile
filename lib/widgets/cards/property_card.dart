import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/config/routes/router.dart';
import 'package:utility_token_app/features/buy/models/meter_details.dart';
import 'package:utility_token_app/features/property/state/property_controller.dart';

import '../../animations/slide_transition_dialog.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/icon_asset_constants.dart';
import '../circular_loader/circular_loader.dart';
import '../dialogs/delete_dialog.dart';
import '../dialogs/update_dialog.dart';
import '../snackbar/custom_snackbar.dart';

class MeterDetailsTile extends StatelessWidget {
  final MeterDetails meter;
  final IconData icon;
  final PropertyController propertyController;
  const MeterDetailsTile({super.key, required this.icon, required this.meter, required this.propertyController,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(
              10
          )
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Pallete.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: SvgPicture.asset(
            CustomIcons.meter,
            semanticsLabel: 'view property',
            height: 40,
          ),
        ),
        title: Text(
          meter.customerName,
          style: const TextStyle(
              color: Colors.grey,
              fontSize: 12
          ),
        ),
        subtitle: Text(
          meter.number,
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
          ),
        ),
        trailing:  PopupMenuButton(
          color: Colors.white,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.pen,
                      color: Colors.grey.shade700,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      'Edit',
                    ),
                  ],

                ),
                onTap: (){
                  Get.dialog(
                      SlideTransitionDialog(
                        child: UpdateDialog(
                            title: 'Meter Number',
                            initialValue: meter.number,
                            onUpdate: (value)async{
                              if((value.isNotEmpty && value.length >= 8)){
                                Get.back();
                                Get.showOverlay(
                                  asyncFunction: () async {
                                    await propertyController.lookUpProperty(
                                      meterNumber: value,
                                    ).then((response){
                                      if(response.success == true){
                                        propertyController.updateProperty(
                                            number: response.data.meter,
                                            updatedProperty: response.data
                                        );
                                        CustomSnackBar.showSuccessSnackbar(message: 'Property Updated Successfully');
                                      }else{
                                        CustomSnackBar.showErrorSnackbar(duration: 8,message:'Failed to update, check your Meter Number and try again');
                                      }
                                    });
                                  },
                                  loadingWidget: const Center(
                                    child: CustomLoader(
                                      message: 'Updating property...',
                                    ),
                                  ),
                                );
                              }else{
                                CustomSnackBar.showErrorSnackbar(message: 'Meter Number number must have at least 8 digits');
                              }
                            }
                        ),
                      )
                  );
                },
              ),
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.trashCan,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Delete',
                    ),
                  ],
                ),
                onTap: (){
                  Get.dialog(
                      DeleteDialog(
                        itemName: 'Property with meter number ${meter.number}',
                        onConfirm: ()async{
                          Get.showOverlay(
                            asyncFunction: () async {
                              await propertyController.deleteProperty(
                                  meter.number
                              ).then((_){
                                Get.toNamed(RoutesHelper.initialScreen);
                              });
                            },
                            loadingWidget: const Center(
                              child: CustomLoader(
                                message: 'Deleting property...',
                              ),
                            ),
                          );

                          CustomSnackBar.showSuccessSnackbar(message: 'Meter Number deleted Successfully');
                        },
                      )
                  );
                },
              ),
            ];
          },
        ),
      ),
    );
  }
}
