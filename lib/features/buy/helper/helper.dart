import 'package:get/get.dart';
import 'package:puc_app/features/buy/state/payment_controller.dart';
import 'package:puc_app/widgets/snackbar/custom_snackbar.dart';
import 'package:puc_app/widgets/circular_loader/circular_loader.dart';

class PaymentHelper {
  /// Validates payment details before proceeding with payment processing.
  /// This includes checking if meter number, amount, and currency are valid.
  static Future<bool> validatePaymentDetails({
    required String meterNumber,
    required String amount,
    required String selectedCurrency,
  }) async {
    final PaymentController paymentController = Get.find<PaymentController>();

    // Validate meter number
    if (!_isValidMeterNumber(meterNumber)) {
      CustomSnackBar.showErrorSnackbar(message: "Meter number cannot be empty.");
      return false;
    }

    // Validate amount
    if (!_isValidAmount(amount)) {
      CustomSnackBar.showErrorSnackbar(message: "Amount must be a valid number greater than zero.");
      return false;
    }

    // Validate currency selection
    if (!_isValidCurrency(selectedCurrency)) {
      CustomSnackBar.showErrorSnackbar(message: "Currency must be selected.");
      return false;
    }

    // Show loading indicator while processing
    Get.dialog(
      barrierDismissible: false,
      const CustomLoader(message: 'Processing your request...'),
    );

    // Attempt to fetch customer details
    try {
      await paymentController.fetchCustomerDetails(
        accessToken: 'k6gX6nDH1ZuDvv0UOP41advUWhvRN0OzL7HR6q1Yop4VbVJT9vvTEyDBo6oHukey2AVSP8tZLS5FpP3gtQnCmyYDCReDyKSji2GDysnIfouTR2zRgeBVV6MSWgPzgd9su22OS2Z9fkxRt7Lzx0rOgPpk9BytVAiHDSdlrYMhYTAujaCf0uYS3Ffbg6klvf1KBsNmjPOhVPmzXMNXcGqq6vi52HHxzsyKGp21arz9ywXwkfaQ',
        meterNumber: meterNumber,
        currency: selectedCurrency,
        amount: double.parse(amount),
      );

      // Check if purchase summary is available after fetching
      if (paymentController.purchaseSummary.value == null) {
        CustomSnackBar.showErrorSnackbar(message: "Unable to retrieve customer details. Please check your meter number and try again.", duration: 8);
        return false;
      }

      return true; // Success case

    } catch (e) {
      // Catch any errors during the fetch operation
      CustomSnackBar.showErrorSnackbar(message: "Error during payment processing. Please try again.");
      return false;
    }
  }

  /// Helper method to check if the meter number is valid (non-empty).
  static bool _isValidMeterNumber(String meterNumber) {
    return meterNumber.isNotEmpty;
  }

  /// Helper method to check if the amount is valid (positive number).
  static bool _isValidAmount(String amount) {
    try {
      final parsedAmount = double.parse(amount);
      return parsedAmount > 0;
    } catch (_) {
      return false;
    }
  }

  /// Helper method to check if the selected currency is valid (non-empty).
  static bool _isValidCurrency(String selectedCurrency) {
    return selectedCurrency.isNotEmpty;
  }

  static String capitalizeFirstLetter(String word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }

}
