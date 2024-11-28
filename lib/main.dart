import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/config/routes/router.dart';
import 'package:utility_token_app/features/buy/state/payment_controller.dart';
import 'package:utility_token_app/features/municipalities/state/municipalities_controller.dart';
import 'package:utility_token_app/features/municipalities/models/municipality.dart';
import 'core/constants/color_constants.dart';
import 'features/municipalities/screens/municipalities_screen.dart';
import 'features/home_screen.dart';
import 'package:device_preview/device_preview.dart';

import 'features/municipalities/state/internet_controller.dart';
import 'features/property/state/property_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ConnectivityController());
  Get.put(MunicipalityController());
  Get.put(PropertyController());
  Get.put(PaymentController());


  // Fetch municipalities on startup
  final municipalityController = Get.find<MunicipalityController>();

  // Check if a municipality is cached
  final cachedMunicipality = await municipalityController.checkCachedMunicipality();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) {
        return MyApp(cachedMunicipality: cachedMunicipality);
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  final Municipality? cachedMunicipality;

  const MyApp({super.key, this.cachedMunicipality});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Pallete.appTheme,
      supportedLocales: const [
        Locale('en'), // English
        Locale('sh'), // Shona
        Locale('nbl') // Ndebele
      ],
      initialRoute: RoutesHelper.splashScreen,
      getPages: RoutesHelper.routes,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: cachedMunicipality != null
          ? HomeScreen(selectedMunicipality: cachedMunicipality!)
          : const MunicipalitiesScreen(),
    );
  }
}
