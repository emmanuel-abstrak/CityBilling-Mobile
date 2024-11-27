import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/config/routes/router.dart';
import '../../../core/constants/icon_asset_constants.dart';
import '../../municipalities/state/municipalities_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final MunicipalityController municipalityController = Get.find<MunicipalityController>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );


    // Fetch municipalities
    municipalityController.fetchMunicipalities();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
        body: Center(
          child: ScaleTransition(
            scale: _animation,
            child: SvgPicture.asset(
              CustomIcons.logo,
              semanticsLabel: 'App Logo',
            ),
          ),
        ),
      );
    });
  }
}
