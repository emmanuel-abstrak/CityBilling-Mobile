// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import '../../../core/constants/image_asset_constants.dart';
// import '../../../widgets/dialogs/update_dialog.dart';
// import '../../../widgets/snackbar/custom_snackbar.dart';
// import '../../../widgets/tiles/profile_option_tile.dart';
// import '../helper/property_helper.dart';
// import '../state/meter_number_controller.dart';
// import '../state/property_controller.dart';
//
// class EditPropertyScreen extends StatefulWidget {
//   const EditPropertyScreen({super.key});
//
//   @override
//   State<EditPropertyScreen> createState() => _EditPropertyScreenState();
// }
//
// class _EditPropertyScreenState extends State<EditPropertyScreen> {
//   final PropertyController propertyController = Get.put(PropertyController());
//
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController meterController = TextEditingController();
//
//   bool hasUnsavedChanges = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     nameController.text = propertyController.property!.name;
//     addressController.text = propertyController.property!.address;
//     meterController.text = propertyController.property!.meterNumber;
//
//     // Track changes
//     nameController.addListener(() => _trackUnsavedChanges());
//     addressController.addListener(() => _trackUnsavedChanges());
//     meterController.addListener(() => _trackUnsavedChanges());
//   }
//
//   void _trackUnsavedChanges() {
//     setState(() {
//       hasUnsavedChanges = nameController.text != propertyController.property!.name ||
//           addressController.text != propertyController.property!.address ||
//           meterController.text != propertyController.property!.meterNumber;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return await PropertyHelper.confirmDiscardChanges(hasUnsavedChanges: hasUnsavedChanges);
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Edit Property',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           actions: [
//             PopupMenuButton(
//               color: Colors.white,
//               itemBuilder: (BuildContext context) {
//                 return [
//                   PopupMenuItem(
//                     child: Row(
//                       children: [
//                         Icon(
//                           FontAwesomeIcons.pen,
//                           color: Colors.grey.shade700,
//                           size: 20,
//                         ),
//                         const SizedBox(
//                           width: 8,
//                         ),
//                         const Text(
//                           'Edit',
//                         ),
//                       ],
//                     ),
//                     onTap: (){
//                       Get.dialog(
//                           UpdateDialog(
//                               title: 'Meter Number',
//                               initialValue: "meterNumber",
//                               onUpdate: (value)async{
//                                 // await PropertyHelper.lookUpDetails(
//                                 //   meterNumber: value,
//                                 // ).then((detailsFound) async{
//                                 //   if(detailsFound){
//                                 //     await meterStateNumberController.updateMeterNumber(
//                                 //       oldMeterNumber: meterNumber,
//                                 //       newMeterNumber: value,
//                                 //     );
//                                 //   }
//                                 // });
//                               }
//                           )
//                       );
//                     },
//                   ),
//                   PopupMenuItem(
//                     child: const Row(
//                       children: [
//                         Icon(
//                           FontAwesomeIcons.trashCan,
//                           color: Colors.redAccent,
//                           size: 20,
//                         ),
//                         SizedBox(
//                           width: 8,
//                         ),
//                         Text(
//                           'Delete',
//                         ),
//                       ],
//                     ),
//                     onTap: (){
//                       // Get.dialog(
//                       //     DeleteDialog(
//                       //       itemName: 'Meter Number: $meterNumber',
//                       //       onConfirm: ()async{
//                       //         await meterStateNumberController.deleteMeterNumber(meterNumber);
//                       //         CustomSnackBar.showSuccessSnackbar(message: 'Meter Number deleted Successfully');
//                       //       },
//                       //     )
//                       // );
//                     },
//                   ),
//                 ];
//               },
//             )
//           ],
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 opacity: 0.5,
//                 image: AssetImage(
//                     LocalImageConstants.bg2
//                 ),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               ProfileOptionTile(
//                 title: "Property Name",
//                 value: nameController.text,
//                 icon: FontAwesomeIcons.building,
//                 onEdit: () async {
//                   await PropertyHelper.updateField(
//                     title: 'Property Name',
//                     initialValue: nameController.text,
//                     onUpdate: (updatedValue) {
//                       setState(() {
//                         nameController.text = updatedValue;
//                       });
//                     },
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//               ProfileOptionTile(
//                 title: "Address",
//                 value: addressController.text,
//                 icon: FontAwesomeIcons.locationDot,
//                 onEdit: () async {
//                   await PropertyHelper.updateField(
//                     title: 'Address',
//                     initialValue: addressController.text,
//                     onUpdate: (updatedValue) {
//                       setState(() {
//                         addressController.text = updatedValue;
//                       });
//                     },
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//               ProfileOptionTile(
//                 title: "Meter Number",
//                 value: meterController.text,
//                 icon: FontAwesomeIcons.tachometerAlt,
//                 onEdit: () async {
//                   await PropertyHelper.updateField(
//                     title: 'Meter Number',
//                     initialValue: meterController.text,
//                     onUpdate: (updatedValue) {
//                       setState(() {
//                         meterController.text = updatedValue;
//                       });
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
