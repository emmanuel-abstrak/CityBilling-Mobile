import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../animations/slide_transition_dialog.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/image_asset_constants.dart';
import '../../../widgets/cards/property_card.dart';
import '../../../widgets/dialogs/add_meter_dialog.dart';
import '../../property/state/property_controller.dart';

class MetersScreen extends StatefulWidget {
  final String title = "Purchase history";
  const MetersScreen({super.key});

  @override
  State<MetersScreen> createState() => _MetersScreenState();
}

class _MetersScreenState extends State<MetersScreen> {
  final PropertyController propertyController = Get.find<PropertyController>();



  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
