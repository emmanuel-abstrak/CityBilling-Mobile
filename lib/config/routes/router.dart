import 'package:get/get.dart';
import 'package:puc_app/features/buy/models/meter_details.dart';
import 'package:puc_app/features/buy/models/purchase_history.dart';
import 'package:puc_app/features/buy/screens/buy_utility_screen.dart';
import 'package:puc_app/features/buy/screens/payment_webview.dart';
import 'package:puc_app/features/home_screen.dart';
import 'package:puc_app/features/splash/splash/splash_screen.dart';
import '../../features/buy/screens/purchase_history.dart';
import '../../features/municipalities/screens/municipalities_screen.dart';
import '../../features/property/screens/property_detail_screen.dart';

class RoutesHelper {
  static String initialScreen = "/";
  static String splashScreen = "/splash";
  static String municipalitiesScreen = '/municipalities';
  static String buyScreen = '/buy';
  static String addProperty = '/addProperty';
  static String propertyDetails = '/propertyDetails';
  static String historyDetails = '/historyDetails';
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
        return PropertyDetailsScreen();
      }
    ),


    GetPage(
      name: historyDetails,
      page: () {
        final PurchaseHistory purchase = Get.arguments as PurchaseHistory;

        return PurchaseHistoryDetailsScreen(
          purchase: purchase,
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

