import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:utility_token_app/features/municipalities/state/municipalities_controller.dart';
import '../../../animations/slide_transition_dialog.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/image_asset_constants.dart';
import '../../../widgets/cards/property_card.dart';
import '../../../widgets/dialogs/add_meter_dialog.dart';
import '../../property/state/property_controller.dart';
import '../../property/state/tutorial_controller.dart';

class MetersScreen extends StatefulWidget {
  final String title = "Purchase history";
  const MetersScreen({super.key});

  @override
  State<MetersScreen> createState() => _MetersScreenState();
}

class _MetersScreenState extends State<MetersScreen> {
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
      body: Obx(() {
        final properties = propertyController.properties.where((property) =>
        property.municipality.name.toLowerCase() == municipalityController.selectedMunicipality.value!.name.toLowerCase()
        ).toList();

        if (properties.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  LocalImageConstants.emptyBox,
                  scale: 4,
                ),
                const Text(
                  "No saved properties",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: properties.length,
          separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
          itemBuilder: (context, index) {
            final property = properties[index];
            return MeterDetailsTile(
              meter: property,
              icon: FontAwesomeIcons.gaugeHigh,
              propertyController: propertyController,
            );
          },
        );
      }),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Add Meter Button
          FloatingActionButton(
            heroTag: 'AddProperty',
            key: addPropertyKey,
            onPressed: () {
              Get.dialog(
                barrierDismissible: false,
                const SlideTransitionDialog(
                  child: AddMeterDialog(
                    title: 'Meter Number',
                    initialValue: '',
                  ),
                ),
              );
            },
            backgroundColor: Pallete.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child:  const Icon(
              Icons.add,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
