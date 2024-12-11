import 'package:get/get.dart';
import '../../../core/utils/logs.dart';
import '../../../core/utils/shared_pref_methods.dart';
import '../api_services/municpalities.dart';
import '../models/municipality.dart';

/// `MunicipalityController` is a controller responsible for managing
/// the state of municipalities in the application, including fetching,
/// caching, and searching.
class MunicipalityController extends GetxController {
  /// List of municipalities that are fetched from the API.
  var municipalities = <Municipality>[].obs;

  var selectedMunicipality = Rx<Municipality?>(null);

  /// List of municipalities filtered by search query.
  var filteredMunicipalities = <Municipality>[].obs;

  /// Boolean to track loading state while fetching municipalities.
  var isLoading = false.obs;

  /// Error message to display in case of failed fetch operations.
  var errorMessage = ''.obs;

  /// Boolean to track if an error occurred during fetch.
  var isError = false.obs;

  /// Current search query for filtering municipalities.
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();

    checkCachedMunicipality();

    // Listen to changes in the search query and update filtered municipalities.
    debounce(
      searchQuery,
          (_) => filterMunicipalities(),
      time: const Duration(milliseconds: 300),
    );
  }

  /// Fetches municipalities from the API and updates the state.
  ///
  /// This method makes an API call to retrieve a list of municipalities.
  /// If successful, it updates the `municipalities` list; otherwise,
  /// it updates the `errorMessage` state.
  Future<void> fetchMunicipalities() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      isError.value = false;

      final response = await MunicipalityServices.getMunicipalities();

      if (response.success) {
        // Update the list of municipalities
        municipalities.value = response.data ?? [];
        filteredMunicipalities.value = municipalities; // Initialize filtered list
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

  /// Retry fetching municipalities when there is a network error.
  Future<void> retryFetchMunicipalities() async {
    await fetchMunicipalities();
  }

  /// Filters municipalities based on the current search query.
  ///
  /// Updates the `filteredMunicipalities` list to show only municipalities
  /// whose names match the search query.
  void filterMunicipalities() {
    if (searchQuery.isEmpty) {
      filteredMunicipalities.value = municipalities;
    } else {
      filteredMunicipalities.value = municipalities
          .where((municipality) =>
          municipality.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }

  /// Checks if a municipality is saved in the cache.
  ///
  /// This method checks if a municipality is available in the cache and
  /// returns it if found, otherwise returns `null`.
  Future<Municipality?> checkCachedMunicipality() async {
    try {
      selectedMunicipality.value = await CacheUtils.getMunicipalityCache();
      return selectedMunicipality.value;
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
      selectedMunicipality.value = municipality;
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