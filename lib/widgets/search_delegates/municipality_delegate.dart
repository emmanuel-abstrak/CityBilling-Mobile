import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/core/constants/color_constants.dart';
import '../../features/home_screen.dart';
import '../../features/municipalities/state/municipalities_controller.dart';
import '../cards/municipality_card.dart';

class MunicipalitySearchDelegate extends SearchDelegate {
  final MunicipalityController municipalityController;

  MunicipalitySearchDelegate(this.municipalityController);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      textTheme: TextTheme(
        headlineMedium: theme.textTheme.headlineMedium?.copyWith(color: Colors.white)
      ),
      appBarTheme: Pallete.appTheme.appBarTheme,
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
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
        GetPlatform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
        color: Colors.white,
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

    return results.isEmpty
        ? _buildNoResultsFound()
        : _buildListView(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = municipalityController.municipalities
        .where((municipality) =>
        municipality.name.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return query.isEmpty
        ? _buildSuggestionPrompt()
        : (suggestions.isEmpty
        ? _buildNoResultsFound()
        : _buildListView(suggestions));
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(
            'Search for a municipality',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List municipalities) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: municipalities.length,
      separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
      itemBuilder: (context, index) {
        final municipality = municipalities[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(
              municipality.name.substring(0, 1).toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            municipality.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () async{
            query = municipality.name;
            showResults(context);


            await municipalityController.cacheMunicipality(municipality);

            Get.offAll(()=> HomeScreen(selectedMunicipality: municipality));

          },
        );
      },
    );
  }
}
