import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/features/municipalities/state/municipalities_controller.dart';
import 'package:utility_token_app/widgets/cards/municipality_card.dart';

import '../../../core/constants/image_asset_constants.dart';
import '../../../widgets/search_delegates/municipality_delegate.dart';

class MunicipalitiesScreen extends StatelessWidget {
  const MunicipalitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MunicipalityController municipalityController = Get.find<MunicipalityController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Providers',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MunicipalitySearchDelegate(municipalityController),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          // Check if municipalities are loaded
          if (municipalityController.municipalities.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: municipalityController.municipalities.length,
            itemBuilder: (context, index) {
              final municipality = municipalityController.municipalities[index];
              return MunicipalityCard(
                municipality: municipality,
              );
            },
          );
        }),
      ),
    );
  }
}

