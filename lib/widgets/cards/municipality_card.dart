import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/features/home_screen.dart';
import '../../features/municipalities/models/municipality.dart';
import '../../features/municipalities/state/municipalities_controller.dart';

class MunicipalityCard extends StatelessWidget {
  final Municipality municipality;

  const MunicipalityCard({
    super.key,
    required this.municipality,
  });

  @override
  Widget build(BuildContext context) {
    final MunicipalityController municipalityController = Get.find<MunicipalityController>();

    return GestureDetector(
      onTap: () async {
        // Cache the selected municipality
        await municipalityController.cacheMunicipality(municipality);

        Get.offAll(()=> HomeScreen(selectedMunicipality: municipality));

      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 8
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
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(municipality.name, style: const TextStyle(fontWeight: FontWeight.bold),),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}

