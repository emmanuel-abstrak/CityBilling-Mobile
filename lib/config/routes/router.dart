import 'package:get/get.dart';
import 'package:utility_token_app/features/buy/screens/buy_utility_screen.dart';
import 'package:utility_token_app/features/buy/screens/payment_webview.dart';
import 'package:utility_token_app/features/home_screen.dart';
import 'package:utility_token_app/features/municipalities/models/municipality.dart';
import 'package:utility_token_app/features/property/screens/add_property_screen.dart';
import 'package:utility_token_app/features/property/screens/property_detail_screen.dart';
import 'package:utility_token_app/features/splash/splash/splash_screen.dart';
import '../../features/municipalities/screens/municipalities_screen.dart';

class RoutesHelper {
  static String initialScreen = "/";
  static String splashScreen = "/splash";
  static String municipalitiesScreen = '/municipalities';
  static String buyScreen = '/buy';
  static String addProperty = '/addProperty';
  static String propertyDetails = '/propertyDetails';
  static String webviewPaymentPage = '/payment-webview';

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: ()=> const SplashScreen()),
    GetPage(name: municipalitiesScreen, page: ()=> const MunicipalitiesScreen()),
    GetPage(name: addProperty, page: ()=> const AddPropertyScreen()),



    GetPage(
      name: initialScreen,
      page: (){
        final municipality = Get.arguments as Municipality;
        return HomeScreen(selectedMunicipality: municipality);
      }
    ),

    GetPage(
      name: propertyDetails,
      page: (){
        return const EditPropertyScreen();
      }
    ),

    GetPage(
     name: buyScreen,
     page: (){
       final municipality = Get.arguments as Municipality;
       return BuyUtilityScreen(municipality: municipality,);
     }

    ),

    GetPage(
        name: webviewPaymentPage,
        page: (){
          final redirectUrl = Get.arguments as String;
          return PaymentWebViewScreen(redirectUrl: redirectUrl,);
        }

    ),

  ];
}

