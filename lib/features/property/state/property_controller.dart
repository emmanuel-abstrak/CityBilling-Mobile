import 'package:get/get.dart';

import '../../../core/utils/api_response.dart';
import '../../../core/utils/logs.dart';
import '../../../core/utils/shared_pref_methods.dart';
import '../../../widgets/snackbar/custom_snackbar.dart';
import '../../buy/models/purchase_summary.dart';
import '../../buy/payment_services/payment_services.dart';
import '../model/property.dart';

/// PropertyController manages the state of the Property globally.
class PropertyController extends GetxController {
  /// Holds the current property data. It's `null` initially until loaded.
  final Rxn<Property> _property = Rxn<Property>();

  /// Getter to access the current property.
  Property? get property => _property.value;

  /// Indicates whether the property data is being loaded.
  final RxBool isLoading = false.obs;

  /// Load the property from the cache.
  Future<void> loadProperty() async {
    isLoading.value = true;
    try {
      final cachedProperty = await CacheUtils.getPropertyCache();
      if (cachedProperty != null) {
        _property.value = cachedProperty;
      }
    } catch (e) {
      DevLogs.logError('Error loading Property: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Save a new property and update the cache.
  Future<void> saveProperty(Property property) async {
    try {
      _property.value = property;
      await CacheUtils.savePropertyToCache(property: property);
    } catch (e) {
      DevLogs.logError('Error saving Property: $e');
    }
  }


  Future<bool> fetchCustomerDetails({
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      CustomSnackBar.showErrorSnackbar(message: "Failed to fetch customer details. Please try again.");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update the current property with new data and persist it.
  ///
  /// Uses the `.copyWith` method to update specific fields while keeping
  /// the rest of the property data intact.
  Future<void> updateProperty({
    required Property updatedProperty
  }) async {
    try {
      await saveProperty(updatedProperty);
    } catch (e) {
      DevLogs.logError('Error updating Property: $e');
    }
  }

  /// Clear the current property and remove it from the cache.
  Future<void> clearProperty() async {
    try {
      _property.value = null;
      await CacheUtils.clearPropertyCache();
    } catch (e) {
      DevLogs.logError('Error clearing Property: $e');
    }
  }

  /// Check if a property is currently loaded.
  bool get hasProperty => _property.value != null;

  @override
  void onInit() {
    super.onInit();
    loadProperty();
  }
}
