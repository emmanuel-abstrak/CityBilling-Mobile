import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/config/routes/router.dart';
import 'package:utility_token_app/features/buy/state/payment_controller.dart';
import 'package:utility_token_app/features/municipalities/state/municipalities_controller.dart';
import 'package:utility_token_app/features/municipalities/models/municipality.dart';
import 'package:utility_token_app/features/property/state/property_controller.dart';
import 'core/constants/color_constants.dart';
import 'features/municipalities/screens/municipalities_screen.dart';
import 'features/home_screen.dart';
import 'features/municipalities/state/internet_controller.dart';
import 'features/property/state/tutorial_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ConnectivityController());
  Get.put(MunicipalityController());
  Get.put(TutorialController());
  Get.put(PropertyController());
  Get.put(PaymentController());

  // Fetch municipalities on startup
  final municipalityController = Get.find<MunicipalityController>();

  // Check if a municipality is cached
  final cachedMunicipality =
      await municipalityController.checkCachedMunicipality();

  runApp(MyApp(cachedMunicipality: cachedMunicipality));
}

class MyApp extends StatelessWidget {
  final Municipality? cachedMunicipality;

  const MyApp({super.key, this.cachedMunicipality});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 700),
      theme: Pallete.appTheme,
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('en'), // English
        Locale('sh'), // Shona
        Locale('nbl') // Ndebele
      ],
      initialRoute: RoutesHelper.splashScreen,
      getPages: RoutesHelper.routes,
      home: cachedMunicipality != null
          ? const HomeScreen()
          : const MunicipalitiesScreen(),
    );
  }
}
