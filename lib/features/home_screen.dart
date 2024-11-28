import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:utility_token_app/config/routes/router.dart';
import 'package:utility_token_app/core/constants/color_constants.dart';
import 'package:utility_token_app/features/municipalities/models/municipality.dart';
import 'package:utility_token_app/features/municipalities/state/municipalities_controller.dart';
import 'package:utility_token_app/features/property/state/property_controller.dart';

import '../core/constants/image_asset_constants.dart';
import '../widgets/tiles/profile_option_tile.dart';


class HomeScreen extends StatefulWidget {
  final Municipality selectedMunicipality;
  const HomeScreen({super.key, required this.selectedMunicipality});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PropertyController propertyController = Get.find<PropertyController>();
  final MunicipalityController municipalityController = Get.find<MunicipalityController>();
  late TutorialCoachMark tutorialCoachMark;
  final GlobalKey addPropertyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (propertyController.property == null) {
        _showTutorial();
      }
    });
  }

  void _showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: "AddProperty",
          keyTarget: addPropertyKey,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: const Text(
                "It looks like you haven't added a property yet. Tap this button to register your property.",
                style: TextStyle(color: Colors.white, fontSize: 18),
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
        return true;
      },
    )..show(context:context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectedMunicipality.name,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.5,
              image: AssetImage(
                  LocalImageConstants.bg2
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          PopupMenuButton(
            color: Colors.white,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.buildingColumns,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        'Municipalities',
                      ),
                    ],
                  ),
                  onTap: ()async{
                    await municipalityController.clearCachedMunicipality().then((_){
                      Get.offAllNamed(RoutesHelper.municipalitiesScreen);
                    });
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.gear,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        'Settings',
                      ),
                    ],
                  ),
                  onTap: ()async{
                    await municipalityController.clearCachedMunicipality().then((_){
                      Get.offAllNamed(RoutesHelper.municipalitiesScreen);
                    });
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.circleInfo,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        'Help',
                      ),
                    ],
                  ),
                  onTap: ()async{

                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.xmark,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        'Exit',
                      ),
                    ],
                  ),
                  onTap: ()async{

                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final property = propertyController.property;

          if (property == null) {
            // No property registered
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_outlined, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No registered property",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tap the '+' button to add your first property.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else {
            // Display property details
            return Container(
              padding: const EdgeInsets.all(16),
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
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.house,
                        color: Pallete.primary,
                        size: 80,
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  ProfileOptionTile(
                    title: "Property Name",
                    value: property.name,
                    icon: FontAwesomeIcons.building,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  ProfileOptionTile(
                    title: "Property Address",
                    value: property.address,
                    icon: FontAwesomeIcons.locationDot,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  ProfileOptionTile(
                    title: "Meter Number",
                    value: property.meterNumber,
                    icon: FontAwesomeIcons.gaugeHigh,
                  ),
                ],
              ),
            );
          }
        }),
      ),
      floatingActionButton: Obx(() {
        final property = propertyController.property;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'AddProperty',
              key: addPropertyKey,
              onPressed: () {
                if (property == null) {
                  // Navigate to Add Property Screen
                  Get.toNamed(RoutesHelper.addProperty);
                } else {
                  // Navigate to Property Details Screen
                  Get.toNamed(RoutesHelper.propertyDetails, arguments: property);
                }
              },
              backgroundColor: Pallete.primary,
              child: Icon(property == null ? Icons.add : FontAwesomeIcons.house, color: Colors.white, size: 20),
            ),

            const SizedBox(
              height: 16,
            ),

            FloatingActionButton(
              heroTag: 'buyUtility',
              backgroundColor: Pallete.success,
              onPressed: () {
                final municipality = widget.selectedMunicipality;

                Get.toNamed(RoutesHelper.buyScreen, arguments: municipality);
              },
              child: const Icon(FontAwesomeIcons.cartShopping, color: Colors.white, size: 20,),
            ),
          ],
        );
      }),
    );
  }
}
