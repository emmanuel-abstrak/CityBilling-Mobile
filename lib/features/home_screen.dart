import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:utility_token_app/config/routes/router.dart';
import 'package:utility_token_app/core/constants/color_constants.dart';
import 'package:utility_token_app/core/constants/image_asset_constants.dart';
import 'package:utility_token_app/features/municipalities/state/municipalities_controller.dart';
import 'package:utility_token_app/features/property/state/property_controller.dart';
import 'package:utility_token_app/features/property/state/tutorial_controller.dart';
import 'package:utility_token_app/widgets/dialogs/add_meter_dialog.dart';
import '../widgets/cards/property_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

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
        title: Obx(() {
            return Text(
              municipalityController.selectedMunicipality.value!.name
            );
          }
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
                ),
                child: const Icon(FontAwesomeIcons.chevronLeft, size: 20,),
              ),
            );
          },
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'AddProperty',
            key: addPropertyKey,
            onPressed: () {
              if (!tutorialController.hasSeenTutorial.value) {
                tutorialController.markTutorialAsSeen();
              }
              Get.dialog(
                barrierDismissible: false,
                const AddMeterDialog(
                  title: 'Meter Number',
                  initialValue: '',
                ),
              );
            },
            backgroundColor: Pallete.secondary,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add Meter',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'buyUtility',
            backgroundColor: Pallete.orange,
            onPressed: () {
              Get.toNamed(RoutesHelper.buyScreen, arguments: null);
            },
            icon: const Icon(
              FontAwesomeIcons.cartShopping,
              color: Colors.white,
            ),
            label: const Text(
              'Buy Utility',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),

    );
  }
}
