import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/core/constants/color_constants.dart';
import 'package:utility_token_app/features/municipalities/state/municipalities_controller.dart';
import 'package:utility_token_app/widgets/cards/municipality_card.dart';
import '../../../widgets/search_delegates/municipality_delegate.dart';

class MunicipalitiesScreen extends StatelessWidget {
  const MunicipalitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MunicipalityController municipalityController =
        Get.find<MunicipalityController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select a provider',
          style: TextStyle(color: Pallete.onSurface,),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(ModernSearchPage(
                  municipalityController: municipalityController));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 14),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: SvgPicture.asset('assets/icons/search-icon.svg'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
        child: Obx(() {
          // Check if municipalities are loaded
          if (municipalityController.municipalities.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.separated(
            itemCount: municipalityController.municipalities.length,
            separatorBuilder: (_, __) => Divider(color: Color(0xFFF4F5FA)),
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
      ),
    );
  }
}
