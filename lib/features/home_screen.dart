import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:utility_token_app/config/routes/router.dart';
import 'package:utility_token_app/core/constants/color_constants.dart';
import 'package:utility_token_app/features/municipalities/models/municipality.dart';
import 'package:utility_token_app/features/municipalities/state/municipalities_controller.dart';
import 'package:utility_token_app/features/property/state/property_controller.dart';


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
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: const Text(
                    'Municipalities'
                  ),
                  onTap: ()async{
                    await municipalityController.clearCachedMunicipality().then((_){
                      Get.offAllNamed(RoutesHelper.municipalitiesScreen);
                    });
                  },
                ),
              ];
            },
          ),

        ],
      ),
      body: Obx(() {
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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text("Address: ${property.address}"),
                    const SizedBox(height: 4),
                    Text("Meter Number: ${property.meterNumber}"),
                  ],
                ),
              ),
            ),
          );
        }
      }),
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
              child: Icon(property == null ? Icons.add : Icons.house),
            ),

            const SizedBox(
              height: 16,
            ),

            FloatingActionButton(
              heroTag: 'buyUtility',
              onPressed: () {
                final municipality = widget.selectedMunicipality;

                Get.toNamed(RoutesHelper.buyScreen, arguments: municipality);
              },
              child: const Icon(Icons.shopping_cart),
            ),
          ],
        );
      }),
    );
  }
}
