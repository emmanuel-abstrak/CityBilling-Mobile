import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  final RxBool isConnected = true.obs;
  final RxString connectionType = "".obs; // To store connection type
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool wasDisconnectedPreviously = false;

  @override
  void onInit() {
    super.onInit();
    // Initial connection check
    _checkConnectivity();
    // Monitor connectivity changes
    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
  }

  void _checkConnectivity() async {
    final List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      // No connection
      isConnected.value = false;
      connectionType.value = "No Connection";
      if (!wasDisconnectedPreviously) {
        wasDisconnectedPreviously = true;
        Get.snackbar(
          "No Internet Connection",
          "Please check your internet settings.",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } else {
      if (!isConnected.value && wasDisconnectedPreviously) {
        // Only show "Internet Restored" if previously disconnected
        Get.snackbar(
          "Internet Restored",
          "You are back online.",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
        wasDisconnectedPreviously = false; // Reset the flag
      }
      isConnected.value = true;

      // Determine connection types
      List<String> activeConnections = [];
      if (results.contains(ConnectivityResult.mobile)) {
        activeConnections.add("Mobile Network");
      }
      if (results.contains(ConnectivityResult.wifi)) {
        activeConnections.add("Wi-Fi");
      }
      if (results.contains(ConnectivityResult.ethernet)) {
        activeConnections.add("Ethernet");
      }
      if (results.contains(ConnectivityResult.bluetooth)) {
        activeConnections.add("Bluetooth");
      }
      if (results.contains(ConnectivityResult.vpn)) {
        activeConnections.add("VPN");
      }
      if (results.contains(ConnectivityResult.other)) {
        activeConnections.add("Other Network");
      }

      connectionType.value = activeConnections.join(", ");

      // Notify when the connection is restored and a switch happens
      if (connectionType.value != "No Connection" && wasDisconnectedPreviously) {
        // First time internet is connected after being offline
        Get.snackbar(
          "Internet Restored",
          "You are back online.",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      }

    }
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
