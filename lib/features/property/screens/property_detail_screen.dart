import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/features/buy/models/meter_details.dart';
import '../../../config/routes/router.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/icon_asset_constants.dart';
import '../../../widgets/circular_loader/circular_loader.dart';
import '../../../widgets/custom_button/general_button.dart';
import '../../../widgets/dialogs/delete_dialog.dart';
import '../../../widgets/dialogs/update_dialog.dart';
import '../../../widgets/snackbar/custom_snackbar.dart';
import '../state/property_controller.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final MeterDetails property;
  const PropertyDetailsScreen({super.key, required this.property});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  final PropertyController propertyController = Get.put(PropertyController());



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.property.customerName,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700
              ),
            ),
            Text(
              widget.property.number,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400
              ),
            ),
          ],
        ),
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: (){
                Get.back();
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-5, -5),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(5, 5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(FontAwesomeIcons.chevronLeft, size: 20,),
              ),
            );
          },
        ),
        actions: [

          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-5, -5),
                  blurRadius: 10,
                ),
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(5, 5),
                  blurRadius: 10,
                ),
              ],
            ),
            child: PopupMenuButton(
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
                            UpdateDialog(
                                title: 'Meter Number',
                                initialValue: widget.property.number,
                                onUpdate: (value)async{
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
                                }
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
                              itemName: 'Property with meter number ${widget.property.number}',
                              onConfirm: ()async{
                                Get.showOverlay(
                                  asyncFunction: () async {
                                    await propertyController.deleteProperty(
                                      widget.property.number
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
          )

        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Recent Purchases',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: Pallete.surface,
        child: Row(
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
              onTap: (){
                Get.toNamed(RoutesHelper.buyScreen, arguments: widget.property);
              },
              width: 200,
              btnColor: Pallete.primary,
              child: const Text(
                'Buy Token',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
