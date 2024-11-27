import 'package:get/get.dart';

import '../../../core/utils/logs.dart';
import '../../../core/utils/shared_pref_methods.dart';
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
