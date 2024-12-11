import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:utility_token_app/core/constants/icon_asset_constants.dart';
import 'package:utility_token_app/widgets/buttons.dart';

import '../../../widgets/cards/purchase_history_tile.dart';
import '../../buy/state/payment_controller.dart';

class HistoryScreen extends StatefulWidget {
  final String title = "Purchase history";
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final PaymentController paymentController = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Observe changes in the purchase history
      if (paymentController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (paymentController.purchaseHistories.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/illustrations/not-found.svg'),
            const Text(
              "You haven't bought tokens yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Click on", style: TextStyle(color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.w600,),),
                SizedBox(width: 5),
                SvgPicture.asset(CustomIcons.buy, height: 20,),
                SizedBox(width: 5),
                Text("to buy", style: TextStyle(color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.w600,),),
              ],
            )
          ],
        );
      } else {
        return ListView.separated(
          itemCount: paymentController.purchaseHistories.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200),
          itemBuilder: (context, index) {
            final purchase = paymentController.purchaseHistories.reversed.toList()[index];
            return PurchaseHistoryTile(
                purchase: purchase
            );
          },
        );
      }
    });
  }
}
