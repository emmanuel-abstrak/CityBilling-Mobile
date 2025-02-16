import 'package:flutter/material.dart';
import 'package:mobile/models/utility_provider.dart';
import 'package:mobile/providers/currency_provider.dart';
import 'package:mobile/screens/purchase/confirm_purchase_screen.dart';
import 'package:mobile/screens/purchase/success_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart' show Uuid; // Generate unique IDs

import '../../models/meter.dart';
import '../../models/transaction.dart';
import '../../providers/theme_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/utility_provider_provider.dart';
import '../../theme/app_colors.dart';

class PurchaseScreen extends StatefulWidget {
  final Meter? meter;
  const PurchaseScreen({super.key, this.meter});

  @override
  PurchaseScreenState createState() => PurchaseScreenState();
}

class PurchaseScreenState extends State<PurchaseScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _meterController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isProcessing = false;
  late String _selectedCurrency = "";

  @override
  void initState() {
    super.initState();
    _meterController.text = widget.meter != null ? widget.meter!.number : '';
    Future.delayed(Duration.zero, () {
      if (mounted) {
        Provider.of<CurrencyProvider>(context, listen: false)
            .fetchCurrencies(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final utilityProvider = Provider.of<UtilityProviderProvider>(context);
    final provider = utilityProvider.selectedUtilityProvider;

    if (currencyProvider.currencies.length == 1) {
      setState(() {
        _selectedCurrency = currencyProvider.currencies[0]["code"];
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buy Token",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _meterController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Meter number",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter Amount",
              ),
            ),
            const SizedBox(height: 20),
            if (currencyProvider.currencies.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(currencyProvider.currencies.length,
                      (int index) {
                    var currency = currencyProvider.currencies[index];
                    return GestureDetector(
                      onTap: () => {
                        setState(() {
                          _selectedCurrency = currency["code"];
                        })
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(color: themeProvider.isDarkMode ? Colors.grey.shade900 : Colors.white,
                          border: Border.all(color: themeProvider.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200, width: 1.5),
                          borderRadius: BorderRadius.circular(8),),
                        child: Row(
                          children: [
                            Icon(Icons.circle, size: 12, color: currency["code"] == _selectedCurrency ? AppColors.primaryRed : Colors.grey.shade300,),
                            SizedBox(width: 10),
                            Text(
                              currency["code"],
                              style: TextStyle(
                                color: currency["code"] == _selectedCurrency ? AppColors.primaryRed : Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            const SizedBox(height: 30),
            _buildBuyButton(provider!, currencyProvider),
          ],
        ),
      ),
    );
  }

  /// **Buy Token Button**
  Widget _buildBuyButton(UtilityProvider provider, CurrencyProvider currencyProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primaryRed,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed:
            _isProcessing ? null : () => _purchaseToken(provider, currencyProvider),
        child: _isProcessing
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Buy Token",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  /// **Handle Token Purchase & Save Transaction**
  void _purchaseToken(UtilityProvider provider, CurrencyProvider currencyProvider) async {
    if (_meterController.text.isEmpty) {
      _showSnackBar("Please enter meter number.");
      return;
    }

    final double? meterNumber = double.tryParse(_meterController.text);
    if (meterNumber == null) {
      _showSnackBar("Invalid meter number.");
      return;
    }

    if (_amountController.text.isEmpty) {
      _showSnackBar("Please enter an amount.");
      return;
    }

    final double amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      _showSnackBar("Invalid amount.");
      return;
    }
    if (_selectedCurrency.isEmpty) {
      _showSnackBar("Please select currency.");
      return;
    }

    // Fetch breakdown of deductions from API (mocked for now)
    List<Map<String, dynamic>> deductions = await _fetchDeductions(amount);
    if (!mounted) return;

    double totalDeductions =
        deductions.fold(0, (sum, item) => sum + item['amount']);
    double finalAmount = amount - totalDeductions;
    double volume = finalAmount / 2.5; // Example conversion for Water & Gas

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmPurchaseScreen(
          meterNumber: meterNumber.toStringAsFixed(0),
          purchaseAmount: amount,
          deductions: deductions,
          finalAmount: finalAmount,
          volume: volume,
          currencyCode: _selectedCurrency,
          onConfirm: () {
            Navigator.pop(context); // Close confirmation screen
            _processPayment(provider, meterNumber, finalAmount, volume, currencyProvider);
          },
        ),
      ),
    );
  }

  /// **Simulate API Call for Detailed Deductions**
  Future<List<Map<String, dynamic>>> _fetchDeductions(double amount) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API delay
    return [
      {"name": "Debt", "amount": amount * 0.10}, // 10% of purchase amount
      {"name": "Service Fee", "amount": 0.50},
      {"name": "Sewer", "amount": 1.00},
    ];
  }

  /// **Process Payment & Redirect to Success Screen**
  void _processPayment(UtilityProvider provider, double meterNumber,
      double finalAmount, double volume, CurrencyProvider currencyProvider) {
    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
      });

      final transaction = Transaction(
        id: const Uuid().v4(),
        provider: provider.id,
        meter: meterNumber.toStringAsFixed(0),
        tokenAmount: finalAmount,
        token: _generateRandomToken(),
        date: DateTime.now().toLocal().toString().split(' ')[0],
        time: TimeOfDay.now().format(context),
        volumePurchased: volume,
        utilityType: "Electricity",
        currencyCode: currencyProvider.selectedCurrency!["code"],
      );

      Provider.of<TransactionProvider>(context, listen: false)
          .addTransaction(transaction);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SuccessScreen(transaction: transaction)),
      );
    });
  }

  String _generateRandomToken() {
    return List.generate(25, (index) => (index % 10).toString()).join();
  }

  /// **Show SnackBar for Errors**
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
