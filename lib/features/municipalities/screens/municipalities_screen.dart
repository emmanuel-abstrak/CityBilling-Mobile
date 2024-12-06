import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          GestureDetector(
            onTap: (){
              Get.to(
                  ModernSearchPage(municipalityController: municipalityController)
              );
            },
            child: Container(
              margin: const EdgeInsets.only(
                right: 16
              ),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-5, -5),
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(5, 5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.search),
            ),
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

