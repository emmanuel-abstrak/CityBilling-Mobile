import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:puc_app/features/municipalities/state/municipalities_controller.dart';
import '../../../animations/slide_transition_dialog.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/icon_asset_constants.dart';
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/illustrations/not-found.svg'),
                const Text(
                  "You haven't saved any meter yet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Click on", style: TextStyle(color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.w600,),),
                    const SizedBox(width: 5),
                    SvgPicture.asset(CustomIcons.buy, height: 20,),
                    const SizedBox(width: 5),
                    Text("to buy", style: TextStyle(color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.w600,),),
                  ],
                )
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: properties.length,
          separatorBuilder: (_, __) => Divider(color: Colors.transparent),
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

      floatingActionButtonLocation: CustomFABLocation(x: 0.9, y: 0.4),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
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
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Pallete.orange,
                borderRadius: BorderRadius.circular(18),
              ),
              child: SvgPicture.asset(CustomIcons.add, height: 15),
            ),
          ),
        ],
      ),
    );
  }
}


class CustomFABLocation extends FloatingActionButtonLocation {
  final double x;
  final double y;

  CustomFABLocation({required this.x, required this.y});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(
      scaffoldGeometry.scaffoldSize.width * x - scaffoldGeometry.floatingActionButtonSize.width / 2,
      scaffoldGeometry.scaffoldSize.height * y - scaffoldGeometry.floatingActionButtonSize.height / 2,
    );
  }
}
