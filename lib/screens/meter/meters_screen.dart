import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/models/meter.dart';
import 'package:mobile/providers/meter_provider.dart';
import 'package:mobile/providers/utility_provider_provider.dart';
import 'package:mobile/screens/meter/add_meter_screen.dart';
import 'package:mobile/screens/meter/edit_meter_screen.dart';
import 'package:mobile/screens/purchase/purchase_screen.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class MetersScreen extends StatelessWidget {
  const MetersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final meterProvider = Provider.of<MeterProvider>(context);
    final utilityProvider = Provider.of<UtilityProviderProvider>(context);
    final meters = meterProvider.getMetersForProvider(
        utilityProvider.selectedUtilityProvider?.id ?? "");

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("My Meters", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
            InkWell(
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset("assets/icons/add.svg", height: 10, color: AppColors.primaryRed,),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMeterScreen()),
                );
              },
            )
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: meters.isEmpty
          ? _buildEmptyState(context)
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: ListView.builder(
                itemCount: meters.length,
                itemBuilder: (context, index) {
                  final meter = meters[index];
                  return _buildMeterCard(context, themeProvider, meterProvider, meter, index);
                },
              ),
            ),
    );
  }

  Widget _buildMeterCard(BuildContext context, ThemeProvider themeProvider, MeterProvider meterProvider,
      Meter meter, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? Colors.grey.shade900 : Colors.white,
        border: Border.all(color: themeProvider.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meter.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(meter.number,
                    style:
                        const TextStyle(fontSize: 14, color: AppColors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: SvgPicture.asset("assets/icons/wallet.svg", height: 22,),
            tooltip: "Buy Token",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PurchaseScreen(meter: meter)),
              );
            },
          ),
          IconButton(
            icon: SvgPicture.asset("assets/icons/edit.svg", height: 22,),
            tooltip: "Edit Meter",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditMeterScreen(meter: meter, index: index)),
              );
            },
          ),
          IconButton(
            icon: SvgPicture.asset("assets/icons/trash.svg", height: 22, color: Colors.redAccent,),
            tooltip: "Delete Meter",
            onPressed: () {
              _confirmDelete(context, themeProvider, meterProvider, index);
            },
          ),
        ],
      ),
    );
  }

  /// **Confirm Meter Deletion**
  void _confirmDelete(
      BuildContext context, ThemeProvider themeProvider, MeterProvider meterProvider, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Meter", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
          content: const Text("Are you sure you want to delete this meter?"),
          backgroundColor: themeProvider.isDarkMode ? Colors.grey.shade900 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(fontSize: 15, color: Colors.grey,fontWeight: FontWeight.w600)),
            ),
            TextButton(
              onPressed: () {
                meterProvider.deleteMeter(index);
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(fontSize: 15, color: Colors.red,fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text("No meters found.\nAdd one to get started!", textAlign: TextAlign.center,),
    );
  }
}
