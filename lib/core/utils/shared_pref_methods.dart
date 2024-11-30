import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:utility_token_app/features/municipalities/models/municipality.dart';
import '../../features/property/model/property.dart';
import 'logs.dart';

/// A utility class for caching and retrieving application data using
/// `SharedPreferences`. This class provides methods to manage onboarding status,
/// properties, and municipalities.
class CacheUtils {
  /// Key for storing onboarding status in the cache.
  static const _onboardingCacheKey = 'hasSeenOnboarding';

  /// Key for storing in app tutorial status in the cache.
  static const _hasSeenTutorialCacheKey = 'hasSeenOnboarding';

  /// Key for storing a cached property in the cache.
  static const _propertyCacheKey = 'cached_property';

  /// Key for storing a cached municipality in the cache.
  static const _municipalityCacheKey = 'cached_municipality';

  /// Key for storing a list of meter numbers in the cache.
  static const _meterNumbersCacheKey = 'cached_meter_numbers';


  // --- Onboarding Methods ---

  /// Checks if the user has completed onboarding.
  ///
  /// This method retrieves the onboarding status from the cache. If no value is
  /// stored, it defaults to `false`.
  ///
  /// Returns:
  /// - `true` if the user has completed onboarding.
  /// - `false` otherwise or in case of an error.
  static Future<bool> checkOnBoardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingCacheKey) ?? false;
    } catch (e) {
      DevLogs.logError('Error checking onboarding status: $e');
      return false;
    }
  }

  static Future<bool> checkTutorialStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_hasSeenTutorialCacheKey) ?? false;
    } catch (e) {
      DevLogs.logError('Error checking onboarding status: $e');
      return false;
    }
  }

  /// Updates the onboarding status in the cache.
  ///
  /// Parameters:
  /// - [status]: The new onboarding status to save (`true` for completed).
  ///
  /// Returns:
  /// - `true` if the status was successfully updated.
  /// - `false` otherwise or in case of an error.
  static Future<bool> updateOnboardingStatus(bool status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCacheKey, status);
      return prefs.getBool(_onboardingCacheKey) ?? false;
    } catch (e) {
      DevLogs.logError('Error updating tutorial status: $e');
      return false;
    }
  }

  static Future<bool> updateHasSeenTutorialStatus(bool status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hasSeenTutorialCacheKey, status);
      return prefs.getBool(_hasSeenTutorialCacheKey) ?? false;
    } catch (e) {
      DevLogs.logError('Error updating tutorial status: $e');
      return false;
    }
  }

  // --- Property Methods ---

  /// Saves a property object to the cache.
  ///
  /// This method serializes the given [property] to JSON and stores it in the
  /// cache under a specific key.
  ///
  /// Parameters:
  /// - [property]: The property to be cached.
  ///
  /// Returns:
  /// - Nothing. Logs an error if caching fails.
  static Future<void> savePropertyToCache({required Property property}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final propertyJson = jsonEncode(property.toJson());
      await prefs.setString(_propertyCacheKey, propertyJson);
    } catch (e) {
      DevLogs.logError('Error saving Property to cache: $e');
    }
  }

  /// Retrieves a property object from the cache.
  ///
  /// This method deserializes the JSON stored in the cache back into a [Property]
  /// object. If no property is cached or if deserialization fails, `null` is
  /// returned.
  ///
  /// Returns:
  /// - A [Property] object if the cache contains valid data.
  /// - `null` otherwise or in case of an error.
  static Future<Property?> getPropertyCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final propertyJson = prefs.getString(_propertyCacheKey);
      if (propertyJson != null) {
        final hostData = jsonDecode(propertyJson) as Map<String, dynamic>;
        return Property.fromJson(hostData);
      }
    } catch (e) {
      DevLogs.logError('Error retrieving Property from cache: $e');
    }
    return null;
  }

  /// Clears the cached property data.
  ///
  /// This method removes the property data stored in the cache.
  ///
  /// Returns:
  /// - Nothing. Logs an error if clearing fails.
  static Future<void> clearPropertyCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_propertyCacheKey);
    } catch (e) {
      DevLogs.logError('Error clearing Property cache: $e');
    }
  }

  // --- Municipality Methods ---

  /// Caches a municipality object.
  ///
  /// This method serializes the given [municipality] to JSON and stores it in the
  /// cache under a specific key.
  ///
  /// Parameters:
  /// - [municipality]: The municipality to be cached.
  ///
  /// Returns:
  /// - Nothing. Logs an error if caching fails.
  static Future<void> cacheMunicipality({required Municipality municipality}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final municipalityJson = jsonEncode(municipality.toJson());
      await prefs.setString(_municipalityCacheKey, municipalityJson);
    } catch (e) {
      DevLogs.logError('Error saving Municipality to cache: $e');
    }
  }

  /// Retrieves a municipality object from the cache.
  ///
  /// This method deserializes the JSON stored in the cache back into a [Municipality]
  /// object. If no municipality is cached or if deserialization fails, `null` is
  /// returned.
  ///
  /// Returns:
  /// - A [Municipality] object if the cache contains valid data.
  /// - `null` otherwise or in case of an error.
  static Future<Municipality?> getMunicipalityCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final municipality = prefs.getString(_municipalityCacheKey);
      if (municipality != null) {
        final hostData = jsonDecode(municipality) as Map<String, dynamic>;
        return Municipality.fromJson(hostData);
      }
    } catch (e) {
      DevLogs.logError('Error retrieving Municipality from cache: $e');
    }
    return null;
  }

  /// Clears the cached municipality data.
  ///
  /// This method removes the municipality data stored in the cache.
  ///
  /// Returns:
  /// - Nothing. Logs an error if clearing fails.
  static Future<void> clearMunicipalityCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_municipalityCacheKey);
    } catch (e) {
      DevLogs.logError('Error clearing Municipality cache: $e');
    }
  }


  // --- Meter Numbers Methods ---

  /// Caches a list of meter numbers.
  ///
  /// This method serializes the given list of [meterNumbers] and stores it in the cache.
  ///
  /// Parameters:
  /// - [meterNumbers]: The list of meter numbers to cache.
  ///
  /// Returns:
  /// - Nothing. Logs an error if caching fails.
  static Future<void> cacheMeterNumbers({required List<String> meterNumbers}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final meterNumbersJson = jsonEncode(meterNumbers);
      await prefs.setString(_meterNumbersCacheKey, meterNumbersJson);
    } catch (e) {
      DevLogs.logError('Error saving meter numbers to cache: $e');
    }
  }

  /// Retrieves the cached list of meter numbers.
  ///
  /// This method deserializes the JSON stored in the cache back into a list of strings.
  /// If no meter numbers are cached or if deserialization fails, an empty list is returned.
  ///
  /// Returns:
  /// - A list of meter numbers if the cache contains valid data.
  /// - An empty list otherwise or in case of an error.
  static Future<List<String>> getMeterNumbersCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final meterNumbersJson = prefs.getString(_meterNumbersCacheKey);
      if (meterNumbersJson != null) {
        return List<String>.from(jsonDecode(meterNumbersJson));
      }
    } catch (e) {
      DevLogs.logError('Error retrieving meter numbers from cache: $e');
    }
    return [];
  }

  /// Deletes a specific meter number from the cache.
  ///
  /// This method retrieves the cached list of meter numbers, removes the specified
  /// [meterNumber] if it exists, and updates the cache.
  ///
  /// Parameters:
  /// - [meterNumber]: The meter number to remove.
  ///
  /// Returns:
  /// - Nothing. Logs an error if deletion fails.
  static Future<void> deleteMeterNumber({required String meterNumber}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentMeterNumbers = await getMeterNumbersCache();
      currentMeterNumbers.remove(meterNumber);
      final updatedMeterNumbersJson = jsonEncode(currentMeterNumbers);
      await prefs.setString(_meterNumbersCacheKey, updatedMeterNumbersJson);
    } catch (e) {
      DevLogs.logError('Error deleting meter number from cache: $e');
    }
  }

  /// Updates a specific meter number in the cache.
  ///
  /// This method retrieves the cached list of meter numbers, replaces the [oldMeterNumber]
  /// with the [newMeterNumber] if it exists, and updates the cache.
  ///
  /// Parameters:
  /// - [oldMeterNumber]: The meter number to update.
  /// - [newMeterNumber]: The new meter number to replace the old one.
  ///
  /// Returns:
  /// - Nothing. Logs an error if updating fails.
  static Future<void> updateMeterNumber({
    required String oldMeterNumber,
    required String newMeterNumber,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentMeterNumbers = await getMeterNumbersCache();
      final index = currentMeterNumbers.indexOf(oldMeterNumber);
      if (index != -1) {
        currentMeterNumbers[index] = newMeterNumber;
        final updatedMeterNumbersJson = jsonEncode(currentMeterNumbers);
        await prefs.setString(_meterNumbersCacheKey, updatedMeterNumbersJson);
      }
    } catch (e) {
      DevLogs.logError('Error updating meter number in cache: $e');
    }
  }

}
