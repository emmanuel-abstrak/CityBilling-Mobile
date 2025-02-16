import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/meter.dart';

class MeterProvider extends ChangeNotifier {
  List<Meter> _meters = [];

  List<Meter> get meters => _meters;

  MeterProvider() {
    _loadMeters();
  }

  /// Load saved meters from local storage
  Future<void> _loadMeters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? metersData = prefs.getString('meters');
    if (metersData != null) {
      List<dynamic> jsonMeters = jsonDecode(metersData);
      _meters = jsonMeters.map((json) => Meter.fromJson(json)).toList();
    }
    notifyListeners();
  }

  /// Save meters to local storage
  Future<void> _saveMeters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonMeters =
        _meters.map((meter) => meter.toJson()).toList();
    await prefs.setString('meters', jsonEncode(jsonMeters));
  }

  /// Add a new meter
  void addMeter(Meter meter, String utilityProviderId) {
    _meters.add(meter);
    _saveMeters();
    notifyListeners();
  }

  /// Edit a meter
  void editMeter(int index, Meter meter) {
    _meters[index] = meter;
    _saveMeters();
    notifyListeners();
  }

  /// Delete a meter
  void deleteMeter(int index) {
    _meters.removeAt(index);
    _saveMeters();
    notifyListeners();
  }

  /// Get meters belonging to the currently selected provider
  List<Meter> getMetersForProvider(String utilityProviderId) {
    return _meters.where((tx) => tx.provider == utilityProviderId)
        .toList();
  }
}
