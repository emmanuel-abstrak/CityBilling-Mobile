import 'package:get/get.dart';
import '../../../core/utils/logs.dart';
import '../../../core/utils/shared_pref_methods.dart';

/// MeterNumberController manages the state of meter numbers globally.
class MeterNumberController extends GetxController {
  /// Holds the list of cached meter numbers.
  final RxList<String> _meterNumbers = <String>[].obs;

  /// Getter to access the list of meter numbers.
  List<String> get meterNumbers => _meterNumbers;

  /// Indicates whether meter numbers are being loaded.
  final RxBool isLoading = false.obs;

  /// Load the meter numbers from the cache.
  Future<void> loadMeterNumbers() async {
    isLoading.value = true;
    try {
      final cachedMeterNumbers = await CacheUtils.getMeterNumbersCache();
      _meterNumbers.assignAll(cachedMeterNumbers);
    } catch (e) {
      DevLogs.logError('Error loading meter numbers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Save the meter numbers to the cache.
  Future<void> saveMeterNumbers(List<String> meterNumbers) async {
    try {
      _meterNumbers.assignAll(meterNumbers);
      await CacheUtils.cacheMeterNumbers(meterNumbers: meterNumbers);
    } catch (e) {
      DevLogs.logError('Error saving meter numbers: $e');
    }
  }

  /// Add a new meter number to the list and update the cache.
  Future<void> addMeterNumber(String meterNumber) async {
    try {
      if (!_meterNumbers.contains(meterNumber)) {
        _meterNumbers.add(meterNumber);
        await CacheUtils.cacheMeterNumbers(meterNumbers: _meterNumbers);
      } else {
        DevLogs.logInfo('Meter number already exists: $meterNumber');
      }
    } catch (e) {
      DevLogs.logError('Error adding meter number: $e');
    }
  }

  /// Delete a meter number from the list and update the cache.
  Future<void> deleteMeterNumber(String meterNumber) async {
    try {
      if (_meterNumbers.remove(meterNumber)) {
        await CacheUtils.cacheMeterNumbers(meterNumbers: _meterNumbers);
      } else {
        DevLogs.logInfo('Meter number not found: $meterNumber');
      }
    } catch (e) {
      DevLogs.logError('Error deleting meter number: $e');
    }
  }

  /// Update a meter number in the list and update the cache.
  Future<void> updateMeterNumber({
    required String oldMeterNumber,
    required String newMeterNumber,
  }) async {
    try {
      final index = _meterNumbers.indexOf(oldMeterNumber);
      if (index != -1) {
        _meterNumbers[index] = newMeterNumber;
        await CacheUtils.cacheMeterNumbers(meterNumbers: _meterNumbers);
      } else {
        DevLogs.logInfo('Old meter number not found: $oldMeterNumber');
      }
    } catch (e) {
      DevLogs.logError('Error updating meter number: $e');
    }
  }

  /// Clear all cached meter numbers.
  Future<void> clearMeterNumbers() async {
    try {
      _meterNumbers.clear();
      await CacheUtils.cacheMeterNumbers(meterNumbers: []);
    } catch (e) {
      DevLogs.logError('Error clearing meter numbers: $e');
    }
  }

  /// Check if any meter numbers are loaded.
  bool get hasMeterNumbers => _meterNumbers.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    loadMeterNumbers();
  }
}
