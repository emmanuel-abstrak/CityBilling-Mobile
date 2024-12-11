import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/config/routes/router.dart';
import 'package:utility_token_app/features/buy/state/payment_controller.dart';
import 'package:utility_token_app/features/municipalities/state/municipalities_controller.dart';
import 'package:utility_token_app/features/property/state/property_controller.dart';
import 'core/constants/color_constants.dart';
import 'features/municipalities/screens/municipalities_screen.dart';
import 'features/home_screen.dart';
import 'features/municipalities/state/internet_controller.dart';
import 'features/property/state/tutorial_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(MunicipalityController());
  Get.put(ConnectivityController());
  Get.put(TutorialController());
  Get.put(PaymentController());
  Get.lazyPut(() => PropertyController());


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final municipalityController = Get.find<MunicipalityController>();

    return GetMaterialApp(
      theme: Pallete.appTheme,
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('en'), // English
        Locale('sh'), // Shona
        Locale('nbl') // Ndebele
      ],
      initialRoute: RoutesHelper.splashScreen,
      getPages: RoutesHelper.routes,
      home: municipalityController.selectedMunicipality.value != null
          ? const HomeScreen()
          : const MunicipalitiesScreen(),
    );
  }
}
