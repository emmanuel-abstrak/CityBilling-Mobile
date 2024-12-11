import 'package:flutter/material.dart';

class MetersScreen extends StatefulWidget {
  final String title = "Purchase history";
  const MetersScreen({super.key});

  @override
  State<MetersScreen> createState() => _MetersScreenState();
}

class _MetersScreenState extends State<MetersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text("Meters"),),
    );
  }
}
