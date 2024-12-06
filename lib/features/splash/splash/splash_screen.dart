import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:utility_token_app/config/routes/router.dart';
import 'package:utility_token_app/core/constants/color_constants.dart';
import 'package:utility_token_app/widgets/dialogs/no_internet.dart';
import '../../../core/constants/icon_asset_constants.dart';
import '../../municipalities/state/municipalities_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  final MunicipalityController municipalityController = Get.find<MunicipalityController>();

  @override
  void initState() {
    super.initState();

    // Fetch municipalities
    municipalityController.fetchMunicipalities();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (municipalityController.isError.value) {
        // Show an error dialog if fetching municipalities fails
        Future.delayed(Duration.zero, () {
          Get.dialog(
            barrierDismissible: false,
            NoInternetDialog(
              controller: municipalityController,
            )
          );
        });
      }

      if (municipalityController.municipalities.isNotEmpty) {
        Future.delayed(Duration.zero, () {
          // Check if the municipality is cached
          municipalityController.checkCachedMunicipality().then((municipality) {
            Future.delayed(Duration.zero, () {
              if (municipality != null) {
                // If municipality is cached, navigate to HomeScreen
                Get.offAllNamed(RoutesHelper.initialScreen, arguments: municipality);
              } else {
                // If no cached municipality, navigate to MunicipalitiesScreen
                Get.offAllNamed(RoutesHelper.municipalitiesScreen);
              }
            });
          });
        });
      }

      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            const SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  CustomIcons.logo,
                  semanticsLabel: 'App Logo',
                  height: 40,
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Pallete.primary,
                ),
              ],
            ),
            const SizedBox(),
          ],
        ),
      );
    });
  }
}
