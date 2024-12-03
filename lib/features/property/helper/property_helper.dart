import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/core/utils/logs.dart';
import 'package:utility_token_app/widgets/dialogs/update_dialog.dart';
import '../../buy/state/payment_controller.dart';
import '../state/property_controller.dart';
import 'package:utility_token_app/features/property/model/property.dart';
import 'package:utility_token_app/widgets/circular_loader/circular_loader.dart';
import 'package:utility_token_app/widgets/snackbar/custom_snackbar.dart';

/// A utility class for managing property-related operations.
class PropertyHelper {
  /// Validates and submits the property data.
  ///
  /// This method ensures that the input fields are valid and then saves the
  /// property using the `PropertyController`.
  ///
  /// Parameters:
  /// - [name]: The name of the property. Must not be empty.
  /// - [address]: The address of the property. Must not be empty.
  /// - [meter]: The meter number of the property. Must be numeric and not empty.
  ///
  /// Displays appropriate feedback to the user for both success and failure cases.
  ///
  /// Returns:
  /// - `true` if the property was successfully added.
  /// - `false` if there was an error during validation or saving.
  static Future<bool> validateAndSubmit({
    required String name,
    required String address,
    required String meter,
  }) async {
    // Input validation
    if (name.trim().isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Property name cannot be empty.');
      return false;
    }

    if (address.trim().isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Property address cannot be empty.');
      return false;
    }

    if (meter.trim().isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Meter number cannot be empty.');
      return false;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(meter)) {
      CustomSnackBar.showErrorSnackbar(message: 'Meter number must be numeric.');
      return false;
    }

    try {
      // Construct the Property object
      final property = Property(
        id: DateTime.now().toIso8601String(),
        name: name.trim(),
        address: address.trim(),
        meterNumber: meter.trim(),
      );

      // Show a loading dialog
      Get.dialog(
        barrierDismissible: false,
        const CustomLoader(message: 'Adding property...'),
      );

      // Save property via controller
      final propertyController = Get.find<PropertyController>();
      await propertyController.saveProperty(property);

      // Dismiss loader and show success message
      Get.back();
      return true;
    } catch (e) {
      // Dismiss loader and show error message
      Get.back();
      CustomSnackBar.showErrorSnackbar(message: 'Failed to add property. Please try again.');
      DevLogs.logError('Error in validateAndSubmit: $e');
      return false;
    }
  }


  /// Confirms if the user wants to discard unsaved changes.
  ///
  /// Parameters:
  /// - [hasUnsavedChanges]: Indicates if there are unsaved changes.
  ///
  /// Returns:
  /// - `true` if the user confirms to discard changes.
  /// - `false` otherwise.
  static Future<bool> confirmDiscardChanges({required bool hasUnsavedChanges}) async {
    if (!hasUnsavedChanges) return true;

    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Unsaved Changes"),
        content: const Text("You have unsaved changes. Are you sure you want to discard them?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("DISCARD"),
          ),
        ],
      ),
    );


    return result ?? false;
  }

  /// Updates a single property field.
  ///
  /// Parameters:
  /// - [title]: The field name to be updated (e.g., "Property Name").
  /// - [initialValue]: The current value of the field.
  /// - [onUpdate]: A callback function to update the field value.
  static Future<void> updateField({
    required String title,
    required String initialValue,
    required Function(String updatedValue) onUpdate,
  }) async {
    final updatedValue = await Get.dialog<String>(
      UpdateDialog(
        title: 'Update $title',
        initialValue: initialValue,
        onUpdate: onUpdate,
      ),
    );

    if (updatedValue != null && updatedValue.trim().isNotEmpty) {
      onUpdate(updatedValue.trim());
    }
  }

  /// Edits and saves property details.
  ///
  /// Parameters:
  /// - [propertyController]: The `PropertyController` instance for saving updates.
  /// - [name]: Updated property name.
  /// - [address]: Updated property address.
  /// - [meter]: Updated meter number.
  ///
  /// Returns:
  /// - `true` if the property was successfully updated.
  /// - `false` otherwise.
  static Future<bool> editProperty({
    required PropertyController propertyController,
    required String name,
    required String address,
    required String meter,
  }) async {
    try {
      // Input validation
      if (name.trim().isEmpty) {
        CustomSnackBar.showErrorSnackbar(message: 'Property name cannot be empty.');
        return false;
      }

      if (address.trim().isEmpty) {
        CustomSnackBar.showErrorSnackbar(message: 'Property address cannot be empty.');
        return false;
      }

      if (meter.trim().isEmpty || !RegExp(r'^[0-9]+$').hasMatch(meter)) {
        CustomSnackBar.showErrorSnackbar(message: 'Meter number must be numeric and not empty.');
        return false;
      }

      // Show a loading dialog
      Get.dialog(
        barrierDismissible: false,
        const CustomLoader(message: 'Updating property...'),
      );

      // Retrieve the selected property and update its fields
      final selectedProperty = propertyController.property!;
      final updatedProperty = selectedProperty.copyWith(
        name: name.trim(),
        address: address.trim(),
        meterNumber: meter.trim(),
      );

      // Save the updated property
      await propertyController.updateProperty(updatedProperty: updatedProperty);

      // Dismiss the loader and show success message
      Get.back();
      CustomSnackBar.showSuccessSnackbar(message: 'Property updated successfully.');
      return true;
    } catch (e) {
      // Dismiss the loader and show error message
      Get.back();
      CustomSnackBar.showErrorSnackbar(message: 'Failed to update property. Please try again.');
      DevLogs.logError('Error in editProperty: $e');
      return false;
    }
  }


  static Future<bool> lookUpDetails({
    required String meterNumber,
  }) async {
    // Show loading indicator while processing
    Get.dialog(
      barrierDismissible: false,
      const CustomLoader(message: 'Checking meter number...'),
    );

    // Attempt to fetch customer details
    try {
      bool success = await Get.find<PropertyController>().fetchCustomerDetails(
        accessToken: 'w7BKImq5uMapLoURhh2cypPv5rdwZy7ExJ968kresYmYCUk2amez784imVgNc0MA0tWxPeftYnotItIcm9eHzdZcLwkhFeedsK7SO7MbyKizrdbXVjzoVKGxGQQmx45mt5hFoQCxctp5D8oJ5WRdXzDgo3OVet1DotsuJdan8YT7aPTkjNTLgmPy6i4vAX1Zj7cSIsiAXiYQWB5mzxfJ7moxICNkfRjRf8q9jimkMd0fnJZF',
        meterNumber: meterNumber,
        currency: 'usd',
        amount: 2,
      );

      Get.back();


      if (!success) {
        CustomSnackBar.showErrorSnackbar(
          message: "Unable to retrieve property details. Please check your meter number and try again.",
          duration: 8,
        );
        return false;
      } else {
        CustomSnackBar.showSuccessSnackbar(
          message: "Property saved successfully",
        );
        return true;
      }
    } catch (e) {
      Get.back();
      DevLogs.logError(e.toString());
      CustomSnackBar.showErrorSnackbar(
        message: "Error during payment processing. Please try again.",
      );
      return false;
    }
  }


}
