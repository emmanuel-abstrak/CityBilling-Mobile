import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/animations/slide_transition_dialog.dart';
import 'package:utility_token_app/features/municipalities/state/municipalities_controller.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/image_asset_constants.dart';
import '../../../widgets/cards/property_card.dart';
import '../../../widgets/dialogs/add_meter_dialog.dart';
import '../state/property_controller.dart';

class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({super.key,});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  final PropertyController propertyController = Get.find<PropertyController>();
  final MunicipalityController municipalityController = Get.find<MunicipalityController>();



  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text(
              'Saved Meters',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700
              ),
            ),

          ],
        ),
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: (){
                Get.back();
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
              propertyController: propertyController,
            );
          },
        );
      }),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Add Meter Button
          FloatingActionButton.extended(
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
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 20,
            ),
            label: const Text(
              'Add Meter',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            elevation: 8,
          ),
        ],
      ),
    );
  }
}
