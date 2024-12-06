import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/core/constants/color_constants.dart';
import 'package:utility_token_app/features/home_screen.dart';
import '../../core/constants/icon_asset_constants.dart';
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
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Pallete.primary.withOpacity(0.3),
          ),
          child: SvgPicture.asset(
            CustomIcons.secure,
            //colorFilter: ColorFilter.mode(Colors.red, BlendMode.clear),
            semanticsLabel: 'Provider type',
            height: 35,
          ),
        ),
        title: Text(municipality.name, style: const TextStyle(fontWeight: FontWeight.w500),),
        trailing: SvgPicture.asset(
          CustomIcons.forward,
          color: Colors.grey,
          //colorFilter: ColorFilter.mode(Colors.red, BlendMode.clear),
          semanticsLabel: 'forward',
          height: 15,
        ),
      ),
    );
  }
}

