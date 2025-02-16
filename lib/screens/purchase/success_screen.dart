import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/models/transaction.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../theme/app_theme.dart';

class SuccessScreen extends StatefulWidget {
  final Transaction transaction;

  const SuccessScreen({super.key, required this.transaction});

  @override
  SuccessScreenState createState() => SuccessScreenState();
}

class SuccessScreenState extends State<SuccessScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Success"),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/success.svg",
                  color: AppTheme.buttonGreen,
                  height: 70,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Token Purchased Successfully!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildTransactionDetails(themeProvider),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.primaryRed,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text("Done",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// **Transaction Details Section**
  Widget _buildTransactionDetails(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? Colors.grey.shade900 : Colors.white,
        border: Border.all(
            color: themeProvider.isDarkMode
                ? Colors.grey.shade800
                : Colors.grey.shade200,
            width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow("Amount",
              "\$${widget.transaction.tokenAmount.toStringAsFixed(2)}"),
          _buildDetailRow("Meter", widget.transaction.meter),
          _buildDetailRow("Token", widget.transaction.token ?? "Pending"),
          _buildDetailRow("Volume Purchased",
              "${widget.transaction.volumePurchased} Units"),
          _buildDetailRow("Transaction Reference", widget.transaction.id),
          _buildDetailRow("Time", widget.transaction.time),
          _buildDetailRow("Utility Type", widget.transaction.utilityType),
        ],
      ),
    );
  }

  /// **Reusable Detail Row**
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
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
