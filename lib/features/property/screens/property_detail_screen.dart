import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/animations/slide_transition_dialog.dart';
import 'package:utility_token_app/features/buy/models/meter_details.dart';
import 'package:utility_token_app/features/buy/state/payment_controller.dart';
import '../../../config/routes/router.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/icon_asset_constants.dart';
import '../../../core/constants/image_asset_constants.dart';
import '../../../widgets/cards/property_card.dart';
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
  final PropertyController propertyController = Get.find<PropertyController>();



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
                            SlideTransitionDialog(
                              child: UpdateDialog(
                                  title: 'Meter Number',
                                  initialValue: widget.property.number,
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

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomLeft,
            child: const Text(
              'Recent Purchases',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        final properties = propertyController.properties;

        if (properties.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  LocalImageConstants.emptyBox,
                  scale: 2,
                ),
                const Text(
                  "No saved properties",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          itemCount: properties.length,
          separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
          itemBuilder: (context, index) {
            final property = properties[index];
            return MeterDetailsTile(
              meter: property,
              icon: FontAwesomeIcons.gaugeHigh,
            );
          },
        );
      }),

      bottomNavigationBar: SizedBox(
        height: 80,
        child: Row(
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
              onTap: (){
                Get.toNamed(RoutesHelper.buyScreen, arguments: widget.property);
              },
              width: 200,
              btnColor: Pallete.primary,
              child: const Text(
                'Buy Token',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
