
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/municipalities/state/municipalities_controller.dart';
import '../cards/municipality_card.dart';

class MunicipalitySearchDelegate extends SearchDelegate {
  final MunicipalityController municipalityController;

  MunicipalitySearchDelegate(this.municipalityController);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        GetPlatform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = municipalityController.municipalities
        .where((municipality) =>
        municipality.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final municipality = results[index];
          return MunicipalityCard(
            municipality: municipality,
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = municipalityController.municipalities
        .where((municipality) =>
        municipality.name.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final municipality = suggestions[index];
          return ListTile(
            title: Text(municipality.name),
            subtitle: Text(municipality.endpoint),
            onTap: () {
              query = municipality.name;
              showResults(context);
            },
          );
        },
      ),
    );
  }
}