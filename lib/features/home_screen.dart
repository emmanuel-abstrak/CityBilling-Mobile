import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:utility_token_app/animations/slide_transition_dialog.dart';
import 'package:utility_token_app/config/routes/router.dart';
import 'package:utility_token_app/core/constants/color_constants.dart';
import 'package:utility_token_app/core/constants/image_asset_constants.dart';
import 'package:utility_token_app/features/buy/screens/buy_utility_screen.dart';
import 'package:utility_token_app/features/history/screens/history.screen.dart';
import 'package:utility_token_app/features/meters/screens/meters.screen.dart';
import 'package:utility_token_app/features/municipalities/state/municipalities_controller.dart';
import 'package:utility_token_app/features/property/state/property_controller.dart';
import 'package:utility_token_app/features/property/state/tutorial_controller.dart';
import 'package:utility_token_app/features/token/screens/buy.screen.dart';
import 'package:utility_token_app/widgets/dialogs/add_meter_dialog.dart';
import '../core/constants/icon_asset_constants.dart';
import '../widgets/cards/property_card.dart';
import '../widgets/cards/purchase_history_tile.dart';
import 'buy/state/payment_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MunicipalityController municipalityController = Get.find<MunicipalityController>();
  final PropertyController propertyController = Get.find<PropertyController>();
  final TutorialController tutorialController = Get.find<TutorialController>();
  late TutorialCoachMark tutorialCoachMark;
  final GlobalKey addPropertyKey = GlobalKey();

  late int selectedPage = 0;
  late String title = "Token History";

  final List<Widget> pages = [
    const HistoryScreen(),
    const BuyScreen(),
    const MetersScreen()
  ];

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold,),
            ),
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                Get.offAllNamed(RoutesHelper.municipalitiesScreen);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Pallete.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Obx(() {
                      return Text(
                          municipalityController.selectedMunicipality.value!.name,
                          style: const TextStyle(fontSize: 13),
                      );
                    }
                    ),
                    const SizedBox(width: 5),
                    SvgPicture.asset(CustomIcons.location, height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: pages[selectedPage],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color:  Color(0xFFF4F5FA)))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  selectedPage = 0;
                  title = "Token History";
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                decoration: BoxDecoration(
                  color: selectedPage == 0 ? Pallete.orange.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(CustomIcons.history, height: 20,),
                    const SizedBox(width: 5),
                    const Text('History', style: TextStyle(fontWeight: FontWeight.w600,),),
                  ],
                ),
              ),
            ),),
            Expanded(child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  selectedPage = 1;
                  title = "Buy Token";
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                decoration: BoxDecoration(
                  color: selectedPage == 1 ? Pallete.orange.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(CustomIcons.buy, height: 20,),
                    const SizedBox(width: 5),
                    const Text('Buy', style: TextStyle(fontWeight: FontWeight.w600,),),
                  ],
                ),
              ),
            ),),
            Expanded(child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  selectedPage = 2;
                  title = "Saved Meters";
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                decoration: BoxDecoration(
                  color:  selectedPage == 2 ? Pallete.orange.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(CustomIcons.card, height: 20,),
                    const SizedBox(width: 5),
                    const Text('Meters', style: TextStyle(fontWeight: FontWeight.w600,),),
                  ],
                ),
              ),
            ),),
          ],
        ),
      ),
    );
  }
}
