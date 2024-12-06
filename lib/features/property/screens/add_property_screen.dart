// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:utility_token_app/config/routes/router.dart';
// import 'package:utility_token_app/core/constants/color_constants.dart';
// import 'package:utility_token_app/features/property/helper/property_helper.dart';
// import 'package:utility_token_app/widgets/custom_button/general_button.dart';
// import 'package:utility_token_app/widgets/text_fields/custom_text_field.dart';
//
// import '../../../widgets/snackbar/custom_snackbar.dart';
//
// class AddPropertyScreen extends StatefulWidget {
//   const AddPropertyScreen({super.key});
//
//   @override
//   State<AddPropertyScreen> createState() => _AddPropertyScreenState();
// }
//
// class _AddPropertyScreenState extends State<AddPropertyScreen> {
//   final _nameController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _meterNumberController = TextEditingController();
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _addressController.dispose();
//     _meterNumberController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Add Property',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 16),
//               CustomTextField(
//                 prefixIcon: const Icon(FontAwesomeIcons.building),
//                 controller: _nameController,
//                 labelText: 'Property Name',
//               ),
//               const SizedBox(height: 16),
//               CustomTextField(
//                 prefixIcon: const Icon(FontAwesomeIcons.locationDot),
//                 controller: _addressController,
//                 labelText: 'Property Address',
//               ),
//               const SizedBox(height: 16),
//               CustomTextField(
//                 prefixIcon: const Icon(FontAwesomeIcons.tachometerAlt),
//                 controller: _meterNumberController,
//                 labelText: 'Meter Number',
//               ),
//               const SizedBox(height: 24),
//               Align(
//                 alignment: Alignment.center,
//                 child: GeneralButton(
//                   onTap: () async {
//                     await PropertyHelper.validateAndSubmit(
//                       name: _nameController.text,
//                       address: _addressController.text,
//                       meter: _meterNumberController.text,
//                     ).then((success){
//                       if(success){
//                         CustomSnackBar.showSuccessSnackbar(message: 'Property added successfully!');
//                         Get.offAllNamed(RoutesHelper.initialScreen);
//                       }
//                     });
//                   },
//                   btnColor: Pallete.primary,
//                   child: const Text(
//                     'Add Property',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
