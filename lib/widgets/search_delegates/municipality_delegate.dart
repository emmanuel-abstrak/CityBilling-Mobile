import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/core/constants/color_constants.dart';
import '../../core/constants/icon_asset_constants.dart';
import '../../features/home_screen.dart';
import '../../features/municipalities/state/municipalities_controller.dart';

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
        GetPlatform.isAndroid ? FontAwesomeIcons.chevronLeft : Icons.arrow_back_ios,
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
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Pallete.primary.withOpacity(0.3),
            ),
            child: SvgPicture.asset(
              CustomIcons.secure,
              //colorFilter: ColorFilter.mode(Colors.red, BlendMode.clear),
              semanticsLabel: 'Provider type',
              height: 35,
            ),
          ),
          title: Text(municipality.name, style: const TextStyle(fontWeight: FontWeight.w500),),
          trailing: SvgPicture.asset(
            CustomIcons.forward,
            color: Colors.grey,
            //colorFilter: ColorFilter.mode(Colors.red, BlendMode.clear),
            semanticsLabel: 'forward',
            height: 15,
          ),
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
