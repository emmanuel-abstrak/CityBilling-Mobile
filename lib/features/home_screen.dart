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
  int _selectedIndex = 0;

  final MunicipalityController municipalityController = Get.find<MunicipalityController>();
  late int selectedPage = 0;
  late String title = "Token History";

  final List<Widget> pages = [
    const HistoryScreen(),
    const BuyScreen(),
    const MetersScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if(index == 0){
        title = "Token History";
      }

      if(index == 1){

        title = "Buy Token";
      }

      if(index == 2){
        title = "Saved Meters";
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
        child: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color:  Color(0xFFF4F5FA)))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            buildBottomNavItem(index: 0, icon:  CustomIcons.history, context:  context, title: 'History'),
            buildBottomNavItem(index: 1, icon:  CustomIcons.buy, context:  context, title: 'Buy'),
            buildBottomNavItem(index: 2, icon:  CustomIcons.card, context:  context, title: 'Meters'),
          ],
        ),
      ),
    );
  }

  Widget buildBottomNavItem({required int index, required String icon, required BuildContext context, required title}) {
    return GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: index == _selectedIndex ? Pallete.orange.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(icon, height: 20,),
              const SizedBox(width: 5),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600,),),
            ],
          ),
        )
    );
  }
}
