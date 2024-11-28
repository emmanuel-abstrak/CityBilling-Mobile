import 'package:get/get.dart';

import '../../../core/utils/logs.dart';
import '../../../core/utils/shared_pref_methods.dart';
import '../api_services/municpalities.dart';
import '../models/municipality.dart';

/// `MunicipalityController` is a controller responsible for managing
/// the state of municipalities in the application. It handles the fetching
/// of municipalities from an API and manages the cache for storing a selected municipality.
class MunicipalityController extends GetxController {

  /// List of municipalities that are fetched from the API.
  var municipalities = <Municipality>[].obs;

  /// Boolean to track loading state while fetching municipalities.
  var isLoading = false.obs;

  /// Error message to display in case of failed fetch operations.
  var errorMessage = ''.obs;

  /// Error code to trigger retry logic
  var isError = false.obs;


  /// Fetches municipalities from the API and updates the state.
  ///
  /// This method makes an API call to retrieve a list of municipalities.
  /// If successful, it updates the `municipalities` list, otherwise, it
  /// updates the `errorMessage` state.


  // Fetches municipalities from the API and updates the state.
  Future<void> fetchMunicipalities() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      isError.value = false;

      final response = await MunicipalityServices.getMunicipalities();

      if (response.success) {
        // Update the list of municipalities
        municipalities.value = response.data ?? [];
        DevLogs.logInfo("Municipalities loaded successfully");
      } else {
        // Update the error message
        errorMessage.value = response.message!;
        isError.value = true;
        DevLogs.logError("Error fetching municipalities: ${response.message}");
      }
    } catch (e, stackTrace) {
      // Handle unexpected errors
      errorMessage.value = "An unexpected error occurred: $e";
      isError.value = true;
      DevLogs.logError("Unexpected error: $e\nStack Trace: $stackTrace");
    } finally {
      isLoading.value = false;
    }
  }

  // Retry fetching municipalities when there is a network error
  Future<void> retryFetchMunicipalities() async {
    await fetchMunicipalities();
  }


  /// Checks if a municipality is saved in the cache.
  ///
  /// This method checks if a municipality is available in the cache and
  /// returns it if found, otherwise returns `null`.
  ///
  /// Returns:
  /// - A `Municipality` object if a cached municipality is found.
  /// - `null` if no cached municipality is found.
  Future<Municipality?> checkCachedMunicipality() async {
    try {
      return await CacheUtils.getMunicipalityCache();
    } catch (e) {
      DevLogs.logError('Error checking cached municipality: $e');
      return null;
    }
  }

  /// Caches the selected municipality.
  ///
  /// This method saves the given municipality to the cache for later use.
  ///
  /// Parameters:
  /// - [municipality] The municipality to cache.
  Future<void> cacheMunicipality(Municipality municipality) async {
    try {
      await CacheUtils.cacheMunicipality(municipality: municipality);
      DevLogs.logInfo('Municipality cached successfully: ${municipality.name}');
    } catch (e) {
      DevLogs.logError('Error caching municipality: $e');
    }
  }

  /// Clears the cached municipality.
  ///
  /// This method removes the cached municipality from storage.
  Future<void> clearCachedMunicipality() async {
    try {
      await CacheUtils.clearMunicipalityCache();
      DevLogs.logInfo('Municipality cache cleared successfully');
    } catch (e) {
      DevLogs.logError('Error clearing municipality cache: $e');
    }
  }
}
