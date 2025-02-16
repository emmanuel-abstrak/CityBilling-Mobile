import 'package:flutter/material.dart';
import 'package:mobile/models/meter.dart';
import 'package:mobile/providers/meter_provider.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:provider/provider.dart';

import '../../providers/utility_provider_provider.dart';

class EditMeterScreen extends StatefulWidget {
  final Meter meter;
  final int index;

  const EditMeterScreen({super.key, required this.meter, required this.index});

  @override
  _EditMeterScreenState createState() => _EditMeterScreenState();
}

class _EditMeterScreenState extends State<EditMeterScreen> {
  late TextEditingController _nameController;
  late TextEditingController _numberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.meter.name);
    _numberController = TextEditingController(text: widget.meter.number);
  }

  @override
  Widget build(BuildContext context) {
    final utilityProvider = Provider.of<UtilityProviderProvider>(context);
    final provider = utilityProvider.selectedUtilityProvider;
    final meterProvider = Provider.of<MeterProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Meter", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
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

                final updatedMeter = Meter(
                  provider: provider!.id,
                  name: _nameController.text,
                  number: _numberController.text,
                );

                meterProvider.editMeter(widget.index, updatedMeter);
                Navigator.pop(context);
              },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.circular(8),

                  ),
                  child: Center(
                    child: Text("Update Meter",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
