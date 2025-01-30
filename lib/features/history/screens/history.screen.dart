import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:puc_app/core/constants/icon_asset_constants.dart';
import 'package:puc_app/features/municipalities/state/municipalities_controller.dart';

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
  final MunicipalityController municipalityController = Get.find<MunicipalityController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final purchases = paymentController.purchaseHistories.reversed.toList().where((purchase) =>
        purchase.municipality.name.toLowerCase() == municipalityController.selectedMunicipality.value!.name.toLowerCase()
      ).toList();
      
      if (paymentController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (purchases.isEmpty) {
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
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Click on", style: TextStyle(color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.w600,),),
                const SizedBox(width: 5),
                SvgPicture.asset(CustomIcons.buy, height: 20,),
                const SizedBox(width: 5),
                Text("to buy", style: TextStyle(color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.w600,),),
              ],
            )
          ],
        );
      } else {
        return ListView.separated(
          itemCount: purchases.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200),
          itemBuilder: (context, index) {
            final purchase = purchases[index];
            return PurchaseHistoryTile(
                purchase: purchase
            );
          },
        );
      }
    });
  }
}
