import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:utility_token_app/config/routes/router.dart';
import 'package:utility_token_app/core/constants/color_constants.dart';
import 'package:utility_token_app/core/constants/image_asset_constants.dart';
import 'package:utility_token_app/features/municipalities/models/municipality.dart';
import 'package:utility_token_app/features/municipalities/state/municipalities_controller.dart';
import 'package:utility_token_app/features/property/helper/property_helper.dart';
import 'package:utility_token_app/features/property/state/property_controller.dart';
import 'package:utility_token_app/features/property/state/tutorial_controller.dart';
import 'package:utility_token_app/widgets/dialogs/add_meter_dialog.dart';
import 'package:utility_token_app/widgets/dialogs/delete_dialog.dart';
import 'package:utility_token_app/widgets/dialogs/update_dialog.dart';
import 'package:utility_token_app/widgets/snackbar/custom_snackbar.dart';
import 'package:utility_token_app/widgets/tiles/profile_option_tile.dart';

class HomeScreen extends StatefulWidget {
  final Municipality selectedMunicipality;
  const HomeScreen({super.key, required this.selectedMunicipality});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PropertyController propertyController = Get.find<PropertyController>();
  final MunicipalityController municipalityController = Get.find<MunicipalityController>();
  final TutorialController tutorialController = Get.find<TutorialController>();

  late TutorialCoachMark tutorialCoachMark;
  final GlobalKey addPropertyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Show the tutorial if it hasn't been shown
      if (!tutorialController.hasSeenTutorial.value) {
       tutorialCoachMark = TutorialCoachMark(
         targets: [
           TargetFocus(
             identify: "AddProperty",

             keyTarget: addPropertyKey,
             contents: [
               TargetContent(
                 align: ContentAlign.top,
                 child: const Text(
                   "It looks like you haven't added a Meter Number yet. Tap the + button to save your Meter Number",
                   style: TextStyle(color: Colors.white, fontSize: 16),
                 ),
               ),
             ],
           ),
         ],
         alignSkip: Alignment.bottomRight,
         skipWidget: const Padding(
           padding: EdgeInsets.all(8.0),
           child: Text("SKIP", style: TextStyle(color: Pallete.primary)),
         ),
         onSkip: () {
           tutorialCoachMark.finish();
           tutorialController.markTutorialAsSeen();
           return true;
         },
       )..show(context: context);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectedMunicipality.name,
        ),
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: ()async{
                await municipalityController.clearCachedMunicipality().then((_) {
                  Get.offAllNamed(RoutesHelper.municipalitiesScreen);
                });
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
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

          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              final municipality = widget.selectedMunicipality;
              return GestureDetector(
                onTap: (){
                  Get.toNamed(RoutesHelper.buyScreen, arguments: [municipality, property]);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6
                  ),
                  child: ProfileOptionTile(
                    title: 'Meter Number',
                    value: property.number,
                    icon: FontAwesomeIcons.gaugeHigh,
                    trailing: PopupMenuButton(
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
                                      initialValue: property.number,
                                      onUpdate: (value)async{
                                        await propertyController.lookUpProperty(
                                          meterNumber: value,
                                        ).then((response) async{
                                          if(response.success == true){
                                            await propertyController.updateProperty(
                                              number: property.number,
                                              updatedProperty: property,
                                            );
                                          }
                                        });
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
                                    itemName: 'Meter Number: $property',
                                    onConfirm: ()async{
                                      await propertyController.deleteProperty(property.number);
                                      CustomSnackBar.showSuccessSnackbar(message: 'Meter Number deleted Successfully');
                                    },
                                  )
                              );
                            },
                          ),
                        ];
                      },
                    )
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'AddProperty',
            key: addPropertyKey,
            onPressed: () {
              if(!tutorialController.hasSeenTutorial.value){
                tutorialController.markTutorialAsSeen();
              }
              Get.dialog(
                barrierDismissible: false,
                const AddMeterDialog(
                  title: 'Meter Number',
                  initialValue: '',
                )
              );
            },
            backgroundColor: Pallete.primary,
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'buyUtility',
            backgroundColor: Pallete.success,
            onPressed: () {
              final municipality = widget.selectedMunicipality;
              Get.toNamed(RoutesHelper.buyScreen, arguments: [municipality, null]);
            },
            child: const Icon(
              FontAwesomeIcons.cartShopping,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
