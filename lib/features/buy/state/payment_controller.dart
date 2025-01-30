import 'package:get/get.dart';
import 'package:puc_app/core/utils/api_response.dart';
import 'package:puc_app/core/utils/logs.dart';
import 'package:puc_app/features/buy/models/purchase_history.dart';
import 'package:puc_app/features/buy/models/purchase_summary.dart';
import 'package:puc_app/widgets/snackbar/custom_snackbar.dart';
import '../../../core/utils/shared_pref_methods.dart';
import '../payment_services/payment_services.dart';

class PaymentController extends GetxController {
  /// Observable flag for loading state.
  RxBool isLoading = false.obs;

  /// Observable to hold purchase summary data.
  Rx<PurchaseSummary?> purchaseSummary = Rx<PurchaseSummary?>(null);

  /// Observable to hold purchase history details.
  Rx<PurchaseHistory?> purchaseHistory = Rx<PurchaseHistory?>(null);


  /// Observable list to hold purchase history.
  RxList<PurchaseHistory> purchaseHistories = RxList<PurchaseHistory>();


  /// Initializes the controller and loads the purchase History.
  ///
  /// This method is called when the controller is initialized. It ensures that
  /// the history is loaded from cache immediately after the controller
  /// is created.
  @override
  void onInit() {
    super.onInit();
    loadCachedPurchaseHistory();
  }

  /// Fetches customer details based on provided meter details.
  ///
  /// [accessToken]: The access token for authentication.
  /// [meterNumber]: The meter number to look up.
  /// [currency]: The currency for the transaction (e.g., USD, ZAR).
  /// [amount]: The amount for the transaction.
  Future<void> fetchCustomerDetails({
    required String accessToken,
    required String meterNumber,
    required String currency,
    required double amount,
  }) async {
    isLoading.value = true;
    try {
      // Call the service to fetch customer details
      APIResponse<PurchaseSummary> response = await PaymentServices.lookUpCustomerDetails(
        accessToken: accessToken,
        meterNumber: meterNumber,
        currency: currency,
        amount: amount,
      );

      // Handle the response
      if (response.success) {
        purchaseSummary.value = response.data;
        Get.back();
      } else {
        Get.back();
      }
    } catch (e) {
      // Handle exceptions
      DevLogs.logError("Error fetching customer details: $e");
      CustomSnackBar.showErrorSnackbar(message: "Failed to fetch customer details. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  /// Initiates a payment and returns the redirect URL for payment processing.
  ///
  /// [accessToken]: The access token for authentication.
  /// [meterNumber]: The meter number for the payment.
  /// [currency]: The currency of the transaction.
  /// [amount]: The amount to be paid.
  Future<APIResponse<String>> initiatePayment({
    required String accessToken,
    required String meterNumber,
    required String currency,
    required double amount,
  }) async {
    try {
      APIResponse<String> response = await PaymentServices.initiatePayment(
        accessToken: accessToken,
        meterNumber: meterNumber,
        currency: currency,
        amount: amount,
      );

      // Log success
      DevLogs.logInfo('Customer details lookup successful for meter number: $meterNumber');

      return response;
    } catch (e, stackTrace) {
      // Log the error and stack trace for detailed debugging
      DevLogs.logError('Error fetching customer details for meter number $meterNumber: $e');
      DevLogs.logError('Stack trace: $stackTrace');

      // Show a custom snackbar with the error message
      CustomSnackBar.showErrorSnackbar(message: "Failed to fetch customer details. Please try again.");

      // Return a response indicating failure
      return APIResponse(
        success: false,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
  /// Retrieves the purchase history details for a specific purchase and stores it to the cache.
  ///
  /// [purchaseId]: The ID of the purchase to retrieve details for.
  /// [accessToken]: The access token for authentication.
  Future<APIResponse<PurchaseHistory>> fetchPurchaseDetailsAndStoreToCache({
    required int purchaseId,
  }) async {
    isLoading.value = true;
    try {
      // Call the service to fetch purchase details
      APIResponse<PurchaseHistory> response = await PaymentServices.getPurchaseDetails(
        purchaseId: purchaseId,
      );

      if (response.success && response.data != null) {
        // Cache the purchase history after retrieving it
        await cachePurchaseHistory(history: response.data!);
      }

      return response;
    } catch (e) {
      // Log and show error
      DevLogs.logError("Error fetching purchase details: $e");
      CustomSnackBar.showErrorSnackbar(message: "Failed to fetch purchase details. Please try again.");
      return APIResponse(
        message: e.toString(),
        success: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Caches the list of purchase history, ensuring new items are appended to the existing cache.
  ///
  /// Parameters:
  /// - [history]: The list of new purchase history items to cache.


  Future<void> cachePurchaseHistory({required PurchaseHistory history}) async {
    try {
      if (!purchaseHistories.any((p) => p.id == history.id)) {
        purchaseHistories.add(history);
        await CacheUtils.cachePurchaseHistory(history: purchaseHistories);

      } else {
        DevLogs.logError('MeterDetails already exists: ${history.id}');

      }
    } catch (e) {
      DevLogs.logError('Error adding MeterDetails: $e');
    }
  }


  /// Retrieves and updates the list of purchase history from the cache.
  ///
  /// This method fetches the cached list of purchase history and updates the
  /// observable [purchaseHistories].
  Future<void> loadCachedPurchaseHistory() async {
    try {
      final history = await CacheUtils.getPurchaseHistoryCache();
      purchaseHistories.assignAll(history ?? []);
    } catch (e) {
      DevLogs.logError("Error loading cached purchase history: $e");
    }
  }


  /// Clears the current purchase summary data.
  void clearSummary() {
    purchaseSummary.value = null;
  }

  /// Clears the current purchase history data.
  void clearHistory() {
    purchaseHistory.value = null;
  }
}
