import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/meter.dart';
import '../../providers/meter_provider.dart';
import '../../providers/utility_provider_provider.dart';
import '../../theme/app_colors.dart';

class AddMeterScreen extends StatefulWidget {
  const AddMeterScreen({super.key});

  @override
  State<AddMeterScreen> createState() => _AddMeterScreenState();
}

class _AddMeterScreenState extends State<AddMeterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final utilityProvider = Provider.of<UtilityProviderProvider>(context);
    final provider = utilityProvider.selectedUtilityProvider;
    final meterProvider = Provider.of<MeterProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Meter", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: "Meter Name"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _numberController,
              decoration: const InputDecoration(hintText: "Meter Number"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                if (_nameController.text.isEmpty ||
                    _numberController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter all fields")),
                  );
                  return;
                }

                final newMeter = Meter(
                  provider: provider!.id,
                  name: _nameController.text,
                  number: _numberController.text,
                );

                meterProvider.addMeter(newMeter, "");
                Navigator.pop(context);
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(8),

                ),
                child: Center(
                  child: Text("Save Meter",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
