import 'package:utility_token_app/widgets/snackbar/custom_snackbar.dart';

/// `PaymentHelper` is a utility class that provides payment-related
/// functions, such as validating payment details like meter number, amount,
/// and selected currency.
class PaymentHelper {
  /// Validates the payment details before proceeding with the payment process.
  ///
  /// This method checks if the meter number, amount, and selected currency
  /// are provided and meet the necessary conditions. If any of the fields
  /// are invalid (empty or improperly formatted), an error message will be
  /// displayed via a custom snackbar.
  ///
  /// Parameters:
  /// - [meterNumber]: The meter number to be validated.
  /// - [amount]: The payment amount to be validated.
  /// - [selectedCurrency]: The selected currency for the payment.
  ///
  /// Returns:
  /// - A `bool` indicating whether the payment details are valid (`true`) or not (`false`).
  static bool validatePaymentDetails({
    required String meterNumber,
    required String amount,
    required String selectedCurrency,
  }) {
    // Check if the meter number is empty
    if (meterNumber.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: "Meter number cannot be empty.");
      return false;
    }

    // Check if the amount is empty
    if (amount.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: "Amount cannot be empty.");
      return false;
    }

    // Check if the amount is a valid number and greater than 0
    if (!_isValidAmount(amount)) {
      CustomSnackBar.showErrorSnackbar(message: "Amount must be a valid number greater than zero.");
      return false;
    }

    // Check if the selected currency is valid (not empty)
    if (selectedCurrency.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: "Currency must be selected.");
      return false;
    }

    // If all validations pass, return true
    return true;
  }

  /// Helper method to check if the provided amount is a valid numeric value
  /// and greater than zero.
  ///
  /// Returns:
  /// - `true` if the amount is a valid number and greater than zero.
  /// - `false` if the amount is invalid or less than or equal to zero.
  static bool _isValidAmount(String amount) {
    try {
      double parsedAmount = double.parse(amount);
      return parsedAmount > 0;
    } catch (e) {
      return false;
    }
  }
}
