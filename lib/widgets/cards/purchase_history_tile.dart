import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utility_token_app/config/routes/router.dart';
import 'package:utility_token_app/features/buy/models/purchase_history.dart';

import '../../core/constants/icon_asset_constants.dart';

class PurchaseHistoryTile extends StatelessWidget {
  final PurchaseHistory purchase;
  const PurchaseHistoryTile({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return ListTile(
      onTap: (){
        Get.toNamed(RoutesHelper.historyDetails, arguments: purchase);
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            purchase.token,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SvgPicture.asset(
            CustomIcons.forward,
            semanticsLabel: 'meter',
            color: Colors.grey,
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Meter Number',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                purchase.meter,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                  dateFormat.format(purchase.createdAt),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount Paid',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                '\$${purchase.totalAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Token Amount',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                "\$${purchase.amount}",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
