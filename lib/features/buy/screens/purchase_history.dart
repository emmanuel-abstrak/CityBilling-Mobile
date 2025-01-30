import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:puc_app/core/constants/color_constants.dart';
import 'package:puc_app/features/buy/helper/helper.dart';
import '../models/purchase_history.dart';

class PurchaseHistoryDetailsScreen extends StatelessWidget {
  final PurchaseHistory purchase;

  const PurchaseHistoryDetailsScreen({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final currencyFormat = NumberFormat.simpleCurrency(name: purchase.currency);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
            builder: (context) {
              return GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: const Icon(FontAwesomeIcons.chevronLeft, size: 20,),
                ),
              );
            },
          ),
        title: const Text(
          'Purchase Details',
        )
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailsCard(context, purchase, dateFormat, currencyFormat),
            const SizedBox(height: 16),
            if(purchase.tariffs.isNotEmpty)_buildTariffsCard(context, purchase),
            if(purchase.tariffs.isNotEmpty) const SizedBox(height: 16),
            _buildTokenCard(context, purchase),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, PurchaseHistory purchase,  DateFormat dateFormat, NumberFormat currencyFormat) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(),
          _buildDetailRow('Meter Number', purchase.meter),
          _buildDetailRow('Date', dateFormat.format(purchase.createdAt)),
          _buildDetailRow('Currency', purchase.currency),
          _buildDetailRow('Amount Paid', "\$${purchase.totalAmount.toStringAsFixed(2)}"),
          _buildDetailRow('Token Amount', currencyFormat.format(double.tryParse(purchase.amount) ?? 0.0)),
          _buildDetailRow('Unit Price', purchase.unitPrice),
          _buildDetailRow('VAT', purchase.vat),
          _buildDetailRow('Volume', purchase.volume),
        ],
      ),
    );
  }

  Widget _buildTariffsCard(BuildContext context, PurchaseHistory purchase) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tariffs',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(),
          ...purchase.tariffs.map((tariff) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                PaymentHelper.capitalizeFirstLetter(tariff.name),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              subtitle: Text(
                'Statement Item ID: ${tariff.statementItemId}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),

              ),
              trailing: Text(
                '\$${tariff.amount.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTokenCard(BuildContext context, PurchaseHistory purchase) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Token',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.qr_code, size: 36, color: Pallete.secondary),
                    const SizedBox(width: 16),
                    Text(
                      purchase.token,
                      style: const TextStyle(fontSize: 14, letterSpacing: 2),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
