import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/core/constants/color_constants.dart';
import 'package:utility_token_app/features/municipalities/state/municipalities_controller.dart';
import 'package:utility_token_app/widgets/cards/municipality_card.dart';
import '../../../widgets/search_delegates/municipality_delegate.dart';

class MunicipalitiesScreen extends StatelessWidget {
  const MunicipalitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MunicipalityController municipalityController = Get.find<MunicipalityController>();

    return Scaffold(
      appBar: AppBar(
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
      body: Obx(() {
        // Check if municipalities are loaded
        if (municipalityController.municipalities.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          itemCount: municipalityController.municipalities.length,
          separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
          itemBuilder: (context, index) {
            final municipality = municipalityController.municipalities[index];
            return Column(
              children: [
                MunicipalityCard(
                  municipality: municipality,
                ),
              ],
            );
          },
        );
      }),
    );
  }
}

