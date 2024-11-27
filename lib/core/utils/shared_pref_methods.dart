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

  /// Key for storing a cached property in the cache.
  static const _propertyCacheKey = 'cached_property';

  /// Key for storing a cached municipality in the cache.
  static const _municipalityCacheKey = 'cached_municipality';

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
      DevLogs.logError('Error updating onboarding status: $e');
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
}
