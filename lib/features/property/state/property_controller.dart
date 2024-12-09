import 'package:get/get.dart';
import 'package:utility_token_app/features/buy/models/meter_details.dart';
import '../../../core/utils/api_response.dart';
import '../../../core/utils/logs.dart';
import '../../../core/utils/shared_pref_methods.dart';
import '../../../widgets/snackbar/custom_snackbar.dart';
import '../../buy/models/purchase_summary.dart';
import '../../buy/payment_services/payment_services.dart';

/// PropertyController manages the state of properties globally.
///
/// This controller is responsible for managing a list of [MeterDetails] objects.
/// It provides methods to load, save, add, delete, update, and clear properties.
/// It also handles the caching of properties in SharedPreferences for persistent storage.
class PropertyController extends GetxController {
  /// Holds the list of cached properties in memory.
  ///
  /// This list is an observable (RxList) and is updated when properties are
  /// added, removed, or modified. It automatically updates the UI when changed.
  final RxList<MeterDetails> _properties = <MeterDetails>[].obs;

  /// Getter to access the list of properties.
  ///
  /// This returns the current list of properties in memory.
  /// It provides a read-only view of the properties list.
  List<MeterDetails> get properties => _properties;

  /// Indicates whether properties are currently being loaded from the cache.
  ///
  /// This boolean value is used to show a loading indicator in the UI when
  /// properties are being loaded or updated.
  final RxBool isLoading = false.obs;

  /// Loads the properties from the cache.
  ///
  /// This method retrieves the cached properties stored in SharedPreferences
  /// and updates the _properties list in memory. It also sets the isLoading
  /// flag to true while loading and false once completed.
  ///
  /// Returns:
  /// - Nothing. It updates the state based on whether loading is successful.
  Future<void> loadProperties() async {
    isLoading.value = true;
    try {
      final cachedProperties = await CacheUtils.getPropertyListCache();
      _properties.assignAll(cachedProperties);
    } catch (e) {
      DevLogs.logError('Error loading properties: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Saves the list of properties to the cache.
  ///
  /// This method serializes the list of properties and stores them in
  /// SharedPreferences for persistent storage.
  ///
  /// Parameters:
  /// - [properties]: The list of properties to save in cache.
  ///
  /// Returns:
  /// - Nothing. If saving fails, an error is logged.
  Future<void> saveProperties(List<MeterDetails> properties) async {
    try {
      _properties.assignAll(properties);
      await CacheUtils.cachePropertyList(properties: properties);
    } catch (e) {
      DevLogs.logError('Error saving properties: $e');
    }
  }

  /// Adds a new MeterDetails to the list and updates the cache.
  ///
  /// This method adds a new MeterDetails to the list of properties if it does
  /// not already exist (checked by MeterDetails number). It then saves the updated
  /// list of properties to the cache.
  ///
  /// Parameters:
  /// - [property]: The new MeterDetails to add to the list.
  ///
  /// Returns:
  /// - Nothing. Logs an error if adding the MeterDetails fails.
  Future<bool?> addNonExistantProperty(MeterDetails property) async {
    try {
      if (!_properties.any((p) => p.number == property.number)) {
        _properties.add(property);
        await CacheUtils.cachePropertyList(properties: _properties);

        return false;
      } else {
        DevLogs.logError('MeterDetails already exists: ${property.number}');
        return true;
      }
    } catch (e) {
      DevLogs.logError('Error adding MeterDetails: $e');
    }
    return null;
  }

  /// Deletes a MeterDetails from the list and updates the cache.
  ///
  /// This method removes a MeterDetails from the list based on its number and then
  /// updates the cache with the modified list.
  ///
  /// Parameters:
  /// - [number]: The ID of the MeterDetails to delete.
  ///
  /// Returns:
  /// - Nothing. Logs an error if the deletion fails.
  Future<void> deleteProperty(String number) async {
    try {
      // Get the current list length before removing
      int initialLength = _properties.length;

      // Remove the MeterDetails
      _properties.removeWhere((p) => p.number == number);

      // Check if the size of the list has changed (i.e., if something was removed)
      if (_properties.length < initialLength) {
        // If the list is smaller, it means a MeterDetails was removed, so update the cache
        await CacheUtils.cachePropertyList(properties: _properties);
      } else {
        // Log info if no MeterDetails was found
        DevLogs.logInfo('MeterDetails not found: $number');
      }
    } catch (e) {
      // Log any errors
      DevLogs.logError('Error deleting MeterDetails: $e');
    }
  }

  /// Updates a MeterDetails in the list and updates the cache.
  ///
  /// This method searches for the MeterDetails by number, replaces the existing
  /// MeterDetails with the updated one, and then saves the updated list to the cache.
  ///
  /// Parameters:
  /// - [number]: The ID of the MeterDetails to update.
  /// - [updatedProperty]: The new MeterDetails object to replace the old one.
  ///
  /// Returns:
  /// - Nothing. Logs an error if the update fails.
  Future<void> updateProperty({
    required String number,
    required MeterDetails updatedProperty,
  }) async {
    try {
      final index = _properties.indexWhere((p) => p.number == number);
      if (index != -1) {
        _properties[index] = updatedProperty;
        await CacheUtils.cachePropertyList(properties: _properties);
      } else {
        DevLogs.logInfo('MeterDetails not found: $number');
      }
    } catch (e) {
      DevLogs.logError('Error updating MeterDetails: $e');
    }
  }

  /// Clears all cached properties.
  ///
  /// This method clears the list of properties in memory and also clears
  /// the cached list in SharedPreferences.
  ///
  /// Returns:
  /// - Nothing. Logs an error if the clearing fails.
  Future<void> clearProperties() async {
    try {
      _properties.clear();
      await CacheUtils.cachePropertyList(properties: []);
    } catch (e) {
      DevLogs.logError('Error clearing properties: $e');
    }
  }

  /// Checks if any properties are currently loaded.
  ///
  /// This boolean value returns true if there are any properties loaded in
  /// memory, otherwise false. It can be used to check whether to display
  /// a message indicating there are no properties.
  ///
  /// Returns:
  /// - [bool]: Returns true if there are properties in memory, false otherwise.
  bool get hasProperties => _properties.isNotEmpty;

  /// Initializes the controller and loads the properties.
  ///
  /// This method is called when the controller is initialized. It ensures that
  /// the properties are loaded from cache immediately after the controller
  /// is created.
  @override
  void onInit() {
    super.onInit();
    loadProperties();
  }

  /// Looks up a property by meter number and fetches customer details.
  ///
  /// This method makes a request to the payment service to fetch the customer details
  /// for a given meter number. It also handles error logging and displays a custom
  /// error snackbar if the request fails.
  ///
  /// Parameters:
  /// - [meterNumber]: The meter number to look up.
  ///
  /// Returns:
  /// - [APIResponse]: Returns an API response object containing either a
  ///   successful [PurchaseSummary] or an error message.
  Future<APIResponse> lookUpProperty({
    required String meterNumber,
  }) async {
    isLoading.value = true;

    try {
      // Attempt to look up customer details using PaymentServices API
      APIResponse<PurchaseSummary> response =
          await PaymentServices.lookUpCustomerDetails(
        accessToken:
            'w7BKImq5uMapLoURhh2cypPv5rdwZy7ExJ968kresYmYCUk2amez784imVgNc0MA0tWxPeftYnotItIcm9eHzdZcLwkhFeedsK7SO7MbyKizrdbXVjzoVKGxGQQmx45mt5hFoQCxctp5D8oJ5WRdXzDgo3OVet1DotsuJdan8YT7aPTkjNTLgmPy6i4vAX1Zj7cSIsiAXiYQWB5mzxfJ7moxICNkfRjRf8q9jimkMd0fnJZF',
        meterNumber: meterNumber,
        currency: 'usd',
        amount: 2,
      );

      // Log success
      DevLogs.logInfo(
          'Customer details lookup successful for meter number: $meterNumber');

      return response;
    } catch (e, stackTrace) {
      // Log the error and stack trace for detailed debugging
      DevLogs.logError(
          'Error fetching customer details for meter number $meterNumber: $e');
      DevLogs.logError('Stack trace: $stackTrace');

      // Show a custom snackbar with the error message
      CustomSnackBar.showErrorSnackbar(
          message: "Failed to fetch customer details. Please try again.");

      // Return a response indicating failure
      return APIResponse(
        success: false,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
