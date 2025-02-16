import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/purchase_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_colors.dart';

class ConfirmPurchaseScreen extends StatefulWidget {
  final String meterNumber;
  final double purchaseAmount;
  final List<Map<String, dynamic>> deductions;
  final double finalAmount;
  final double volume;
  final String currencyCode;
  final VoidCallback onConfirm;

  const ConfirmPurchaseScreen({
    super.key,
    required this.meterNumber,
    required this.purchaseAmount,
    required this.deductions,
    required this.finalAmount,
    required this.volume,
    required this.currencyCode,
    required this.onConfirm,
  });

  @override
  State<ConfirmPurchaseScreen> createState() => _ConfirmPurchaseScreenState();
}

class _ConfirmPurchaseScreenState extends State<ConfirmPurchaseScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) {
        Provider.of<PurchaseProvider>(context, listen: false).lookup(context,
            widget.meterNumber, widget.purchaseAmount, widget.currencyCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final purchaseProvider = Provider.of<PurchaseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Confirm Purchase",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: purchaseProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : purchaseProvider.error.isNotEmpty
              ? Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeProvider.isDarkMode
                          ? Colors.grey.shade900
                          : Colors.white,
                      border: Border.all(
                          color: themeProvider.isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                          width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(purchaseProvider.error),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: themeProvider.isDarkMode
                              ? Colors.grey.shade900
                              : Colors.grey.shade100,
                          border: Border.all(
                              color: themeProvider.isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200,
                              width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow("Meter Number", widget.meterNumber),
                            _buildDetailRow("Requested Amount",
                                widget.purchaseAmount.toStringAsFixed(2)),
                            _buildDetailRow("Currency", widget.currencyCode),
                            _buildDeductionsList(), // Show detailed deductions
                            _buildDetailRow("Final Amount",
                                widget.finalAmount.toStringAsFixed(2)),
                            _buildDetailRow("Volume (m³)",
                                "${widget.volume.toStringAsFixed(2)} m³"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColors.primaryRed,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: widget.onConfirm,
                            child: Text(
                              "Make payment",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancel",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.primaryRed, fontSize: 16),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
    );
  }

  /// **Display Each Deduction Separately**
  Widget _buildDeductionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Deductions",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 5),
        ...widget.deductions.map((deduction) => Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(deduction['name'],
                      style: const TextStyle(color: AppColors.grey)),
                  Text("-${deduction['amount'].toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.redAccent)),
                ],
              ),
            )),
      ],
    );
  }

  /// **Reusable Detail Row**
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(color: AppColors.grey)),
        ],
      ),
    );
  }
}
