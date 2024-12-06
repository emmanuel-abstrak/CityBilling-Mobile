import 'package:get/get.dart';
import 'package:utility_token_app/features/buy/models/meter_details.dart';
import 'package:utility_token_app/features/buy/screens/buy_utility_screen.dart';
import 'package:utility_token_app/features/buy/screens/payment_webview.dart';
import 'package:utility_token_app/features/home_screen.dart';
import 'package:utility_token_app/features/splash/splash/splash_screen.dart';
import '../../features/municipalities/screens/municipalities_screen.dart';
import '../../features/property/screens/property_detail_screen.dart';

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


    GetPage(
      name: initialScreen,
      page: (){
        return const HomeScreen();
      }
    ),

    GetPage(
      name: propertyDetails,
      page: (){
        final property = Get.arguments as MeterDetails;

        return PropertyDetailsScreen(property: property);
      }
    ),

    GetPage(
      name: buyScreen,
      page: () {
        final MeterDetails? property = Get.arguments as MeterDetails?;

        return BuyUtilityScreen(
          selectedProperty: property,
        );
      },
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

