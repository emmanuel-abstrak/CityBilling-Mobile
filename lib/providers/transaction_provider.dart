import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  TransactionProvider() {
    _loadTransactions();
  }

  /// Load transactions from local storage
  Future<void> _loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? transactionsData = prefs.getString('transactions');
    if (transactionsData != null) {
      List<dynamic> jsonList = jsonDecode(transactionsData);
      _transactions =
          jsonList.map((json) => Transaction.fromJson(json)).toList();
    }
    notifyListeners();
  }

  /// Save transactions locally
  Future<void> _saveTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList =
        _transactions.map((tx) => tx.toJson()).toList();
    await prefs.setString('transactions', jsonEncode(jsonList));
  }

  /// Add a new transaction
  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    _saveTransactions();
    notifyListeners();
  }

  List<Transaction> getTransactionsForProvider(String utilityProviderId) {
    return _transactions.where((tx) => tx.provider == utilityProviderId)
        .toList();
  }
}
