import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/config/routes/router.dart';
import 'package:utility_token_app/features/buy/models/meter_details.dart';

import '../../core/constants/color_constants.dart';
import '../../core/constants/icon_asset_constants.dart';

class MeterDetailsTile extends StatelessWidget {
  final MeterDetails meter;
  final IconData icon;
  const MeterDetailsTile({super.key, required this.icon, required this.meter,});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: Colors.grey.shade700,
      ),
      title: Text(
        meter.customerName,
        style: const TextStyle(
            color: Colors.grey,
            fontSize: 12
        ),
      ),
      subtitle: Text(
        meter.number,
        style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
        ),
      ),
      trailing: SvgPicture.asset(
        CustomIcons.forward,
        semanticsLabel: 'view property',
        color: Colors.grey,
        height: 15,
      ),
      onTap: (){
        Get.toNamed(RoutesHelper.propertyDetails, arguments: meter);
      },
    );
  }
}
