import 'package:get/get.dart';
import 'package:utility_token_app/config/routes/router.dart';
import 'package:utility_token_app/core/utils/api_response.dart';
import 'package:utility_token_app/core/utils/logs.dart';
import 'package:utility_token_app/features/buy/models/purchase_summary.dart';
import 'package:utility_token_app/widgets/snackbar/custom_snackbar.dart';
import '../payment_services/payment_services.dart';

class PaymentController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<PurchaseSummary?> purchaseSummary = Rx<PurchaseSummary?>(null);

  /// Fetches customer details from the API based on provided payment details.
  Future<void> fetchCustomerDetails({
    required String accessToken,
    required String meterNumber,
    required String currency,
    required double amount,
  }) async {
    isLoading.value = true;

    try {
      APIResponse<PurchaseSummary> response = await PaymentServices.lookUpCustomerDetails(
        accessToken: accessToken,
        meterNumber: meterNumber,
        currency: currency,
        amount: amount,
      );

      if (response.success) {
        purchaseSummary.value = response.data;
        Get.back();
      } else {
        Get.back();
        CustomSnackBar.showErrorSnackbar(message: response.message!);
      }
    } catch (e) {
      CustomSnackBar.showErrorSnackbar(message: "Failed to fetch customer details. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  /// Initiates the payment and provides the redirect URL for payment processing.
  Future<void> initiatePayment({
    required String accessToken,
    required String meterNumber,
    required String currency,
    required double amount,
  }) async {
    isLoading.value = true;

    try {
      APIResponse<String> response = await PaymentServices.initiatePayment(
        accessToken: accessToken,
        meterNumber: meterNumber,
        currency: currency,
        amount: amount,
      );

      if (response.success) {
        String redirectUrl = response.data!;

        DevLogs.logSuccess(redirectUrl);
        Get.back();
        Get.toNamed(RoutesHelper.webviewPaymentPage, arguments: redirectUrl);
      } else {
        Get.back();
        CustomSnackBar.showErrorSnackbar(message: response.message!);
      }
    } catch (e) {
      CustomSnackBar.showErrorSnackbar(message: "Failed to initiate payment. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  /// Clears the current purchase summary.
  void clearSummary() {
    purchaseSummary.value = null;
  }
}
