import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:utility_token_app/animations/slide_transition_dialog.dart';
import 'package:utility_token_app/config/routes/router.dart';
import 'package:utility_token_app/core/constants/color_constants.dart';
import 'package:utility_token_app/core/constants/image_asset_constants.dart';
import 'package:utility_token_app/features/municipalities/state/municipalities_controller.dart';
import 'package:utility_token_app/features/property/state/property_controller.dart';
import 'package:utility_token_app/features/property/state/tutorial_controller.dart';
import 'package:utility_token_app/widgets/dialogs/add_meter_dialog.dart';
import '../core/constants/icon_asset_constants.dart';
import '../widgets/cards/property_card.dart';
import 'buy/state/payment_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MunicipalityController municipalityController = Get.find<MunicipalityController>();
  final PaymentController paymentController = Get.find<PaymentController>();
  final PropertyController propertyController = Get.find<PropertyController>();
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          // Observe changes in the purchase history
          if (paymentController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (paymentController.purchaseHistories.isEmpty) {
            return const Center(
              child: Text(
                'No recent purchases available.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          } else {
            return ListView.separated(
              itemCount: paymentController.purchaseHistories.length,
              separatorBuilder: (context, index) => const Divider(color: Colors.grey),
              itemBuilder: (context, index) {
                final purchase = paymentController.purchaseHistories[index];
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        purchase.token,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SvgPicture.asset(
                        CustomIcons.forward,
                        semanticsLabel: 'meter',
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            purchase.createdAt.toString(),
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount Paid',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '\$${purchase.amount}',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       'Token Amount',
                      //       style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //     Text(
                      //       '\$${purchase..toStringAsFixed(2)}',
                      //       style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                );
              },
            );
          }
        }),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Add Meter Button
          FloatingActionButton.extended(
            heroTag: 'AddProperty',
            key: addPropertyKey,
            onPressed: () {
              if (!tutorialController.hasSeenTutorial.value) {
                tutorialController.markTutorialAsSeen();
              }

              if(propertyController.properties.isEmpty){
                Get.dialog(
                  barrierDismissible: false,
                  const SlideTransitionDialog(
                    child: AddMeterDialog(
                      title: 'Meter Number',
                      initialValue: '',
                    ),
                  ),
                );
              }else{
                Get.toNamed(RoutesHelper.propertyDetails);
              }
            },
            backgroundColor: Pallete.secondary,
            icon: Icon(
              propertyController.properties.isEmpty ? Icons.add :FontAwesomeIcons.gaugeHigh,
              color: Colors.white,
              size: 20,
            ),
            label: Text(
              propertyController.properties.isEmpty ? 'Add Meter' : 'Saved Meters',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            elevation: 8, // Added shadow
          ),
          const SizedBox(height: 12),
          // Buy Utility Button
          FloatingActionButton.extended(
            heroTag: 'buyUtility',
            onPressed: () {
              Get.toNamed(RoutesHelper.buyScreen, arguments: null);
            },
            backgroundColor: Pallete.orange,
            icon: const Icon(
              FontAwesomeIcons.cartShopping,
              color: Colors.white,
              size: 20,
            ),
            label: const Text(
              'Buy Token',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14, // Slightly smaller text
                fontWeight: FontWeight.bold,
              ),

            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            elevation: 8, // Added shadow
          ),
        ],
      ),

    );
  }
}
