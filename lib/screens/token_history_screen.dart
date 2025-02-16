import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/screens/purchase/purchase_screen.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../providers/theme_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/utility_provider_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class TokenHistoryScreen extends StatefulWidget {
  const TokenHistoryScreen({super.key});

  @override
  _TokenHistoryScreenState createState() => _TokenHistoryScreenState();
}

class _TokenHistoryScreenState extends State<TokenHistoryScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final utilityProvider = Provider.of<UtilityProviderProvider>(context);
    final provider = utilityProvider.selectedUtilityProvider;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    List<Transaction> transactions =
        _filterAndSortTransactions(transactionProvider.getTransactionsForProvider(provider!.id));

    return Scaffold(
      appBar: AppBar(
        title: _buildSearch(themeProvider),
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          Expanded(
            child: transactions.isEmpty
                ? _buildEmptyState()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return _buildTransactionCard(themeProvider, transaction);
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PurchaseScreen()),
          )
        },
        child: Container(
          height: 40,
          width: 110,
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Center(
            child: Text("Buy Token", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
          ),
        ),
      ),
    );
  }

  /// **Search Input with Filter Button**
  Widget _buildSearch(ThemeProvider themeProvider) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset(themeProvider.isDarkMode ? "assets/logo-white.svg" : "assets/logo.svg", height: 26),
          SizedBox(width: 20),
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search tokens",
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9.0),
                  child: SvgPicture.asset(
                    "assets/icons/search.svg",
                    width: 18,
                    height: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **Filter & Sort Transactions**
  List<Transaction> _filterAndSortTransactions(List<Transaction> transactions) {
    if (_searchQuery.isNotEmpty) {
      transactions = transactions
          .where((tx) =>
              tx.meter.toLowerCase().contains(_searchQuery) ||
              tx.token?.contains(_searchQuery) == true ||
              tx.id.contains(_searchQuery))
          .toList();
    }

    return transactions;
  }

  /// **Custom Transaction Card**
  Widget _buildTransactionCard(ThemeProvider themeProvider, Transaction transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? Colors.grey.shade900 : Colors.white,
        border: Border.all(color: themeProvider.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 10),
        childrenPadding: EdgeInsets.symmetric(horizontal: 0),
        collapsedShape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: themeProvider.isDarkMode ? AppTheme.darkBackground : Colors.grey.shade100,
        title: Text("${transaction.currencyCode} ${transaction.tokenAmount.toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(transaction.formattedToken, style: TextStyle(fontSize: 13),),
        children: [
          ListTile(
              title: const Text("Meter"), subtitle: Text(transaction.meter)),
          ListTile(
              title: const Text("Utility"),
              subtitle: Text(transaction.utilityType)),
          ListTile(
              title: const Text("Token"),
              subtitle: Text(transaction.formattedToken ?? "Pending")),
          ListTile(
              title: const Text("Volume"),
              subtitle: Text("${transaction.volumePurchased} Units")),
          ListTile(title: const Text("Date"), subtitle: Text("${transaction.date} ${transaction.time}")),
        ],
      ),
    );
  }

  /// **Empty State for No Transactions**
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/icons/receipt.svg", color: AppColors.primaryRed, height: 60),
          const SizedBox(height: 10),
          const Text(
            "No tokens yet.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
