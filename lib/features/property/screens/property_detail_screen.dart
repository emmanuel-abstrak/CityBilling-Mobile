import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../core/constants/image_asset_constants.dart';
import '../../../widgets/snackbar/custom_snackbar.dart';
import '../../../widgets/tiles/profile_option_tile.dart';
import '../helper/property_helper.dart';
import '../state/property_controller.dart';

class EditPropertyScreen extends StatefulWidget {
  const EditPropertyScreen({super.key});

  @override
  State<EditPropertyScreen> createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  final PropertyController propertyController = Get.put(PropertyController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController meterController = TextEditingController();

  bool hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();

    nameController.text = propertyController.property!.name;
    addressController.text = propertyController.property!.address;
    meterController.text = propertyController.property!.meterNumber;

    // Track changes
    nameController.addListener(() => _trackUnsavedChanges());
    addressController.addListener(() => _trackUnsavedChanges());
    meterController.addListener(() => _trackUnsavedChanges());
  }

  void _trackUnsavedChanges() {
    setState(() {
      hasUnsavedChanges = nameController.text != propertyController.property!.name ||
          addressController.text != propertyController.property!.address ||
          meterController.text != propertyController.property!.meterNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await PropertyHelper.confirmDiscardChanges(hasUnsavedChanges: hasUnsavedChanges);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Property',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: hasUnsavedChanges
                  ? () async {
                await PropertyHelper.editProperty(
                  propertyController: propertyController,
                  name: nameController.text,
                  address: addressController.text,
                  meter: meterController.text,
                ).then((success) {
                  if (success) {
                    setState(() {
                      hasUnsavedChanges = false;
                    });
                    Get.back();
                    CustomSnackBar.showSuccessSnackbar(message: 'Property updated successfully');
                  } else {
                    CustomSnackBar.showErrorSnackbar(message: 'Failed to update property.');
                  }
                });
              }
                  : null,
              child: Text(
                'SAVE',
                style: TextStyle(
                  color: hasUnsavedChanges ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(LocalImageConstants.bg),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ProfileOptionTile(
                title: "Property Name",
                value: nameController.text,
                icon: FontAwesomeIcons.building,
                onEdit: () async {
                  await PropertyHelper.updateField(
                    title: 'Property Name',
                    initialValue: nameController.text,
                    onUpdate: (updatedValue) {
                      setState(() {
                        nameController.text = updatedValue;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              ProfileOptionTile(
                title: "Address",
                value: addressController.text,
                icon: FontAwesomeIcons.locationDot,
                onEdit: () async {
                  await PropertyHelper.updateField(
                    title: 'Address',
                    initialValue: addressController.text,
                    onUpdate: (updatedValue) {
                      setState(() {
                        addressController.text = updatedValue;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              ProfileOptionTile(
                title: "Meter Number",
                value: meterController.text,
                icon: FontAwesomeIcons.tachometerAlt,
                onEdit: () async {
                  await PropertyHelper.updateField(
                    title: 'Meter Number',
                    initialValue: meterController.text,
                    onUpdate: (updatedValue) {
                      setState(() {
                        meterController.text = updatedValue;
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
