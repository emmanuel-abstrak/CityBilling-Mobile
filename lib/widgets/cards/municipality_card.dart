import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:puc_app/core/constants/color_constants.dart';
import 'package:puc_app/features/home_screen.dart';
import '../../core/constants/icon_asset_constants.dart';
import '../../features/municipalities/models/municipality.dart';
import '../../features/municipalities/state/municipalities_controller.dart';
import '../../features/property/state/property_controller.dart';
import '../circular_loader/circular_loader.dart';

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
        Get.showOverlay(
          asyncFunction: () async {
            await municipalityController.cacheMunicipality(municipality);
            Get.offAll(() => const HomeScreen());
          },
          loadingWidget: const Center(
            child: CustomLoader(
              message: 'Please wait',
            ),
          ),
        );
      },

      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Pallete.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: SvgPicture.asset(
            municipality.type == 'private' ? CustomIcons.secure : CustomIcons.location,
            semanticsLabel: 'Provider type',
            height: 25,
          ),
        ),
        title: Text(municipality.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15,),),
        trailing: SvgPicture.asset(
          CustomIcons.forward,
          semanticsLabel: 'forward',
          height: 12,
        ),
      ),
    );
  }
}

