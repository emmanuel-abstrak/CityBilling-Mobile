import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/core/utils/logs.dart';
import 'package:utility_token_app/widgets/circular_loader/circular_loader.dart';
import 'package:utility_token_app/widgets/text_fields/custom_text_field.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/icon_asset_constants.dart';
import '../../features/home_screen.dart';
import '../../features/municipalities/state/municipalities_controller.dart';
import '../../features/property/state/property_controller.dart';

class ModernSearchPage extends StatefulWidget {
  final MunicipalityController municipalityController;

  const ModernSearchPage({required this.municipalityController, super.key});

  @override
  State<ModernSearchPage> createState() => _ModernSearchPageState();
}

class _ModernSearchPageState extends State<ModernSearchPage> {
  String query = '';
  List suggestions = [];
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildSearchAppBar(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: query.isEmpty
            ? _buildSuggestionPrompt()
            : suggestions.isEmpty
            ? _buildNoResultsFound()
            : _buildListView(suggestions),
      ),
    );
  }

  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      title: CustomTextField(
        suffixIconButton: query.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear, color: Colors.grey),
          onPressed: () {
            setState(() {
              query = '';
              suggestions = [];
              searchController.clear();
            });
          },
        ) : null,
        focusNode: FocusNode(
          canRequestFocus: true
        ),
        onChanged: (value) {
          setState(() {
            DevLogs.logSuccess('');
            query = value!;
            suggestions = widget.municipalityController.municipalities
                .where((municipality) =>
                municipality.name.toLowerCase().contains(query.toLowerCase()))
                .toList();
          });
        },
        labelText: 'Search Provider...',
        controller: searchController,
        prefixIcon: const Icon(FontAwesomeIcons.magnifyingGlass, color: Colors.grey,),
      ),
    );
  }

  Widget _buildSuggestionPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            FontAwesomeIcons.magnifyingGlass,
            size: 50,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Start typing to search',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/illustrations/not-found.svg'),
          const Text(
            "No results found",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List municipalities) {
    return RefreshIndicator(
      onRefresh: () async {
        // Optionally refresh the data
        setState(() {});
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: municipalities.length,
        separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
        itemBuilder: (context, index) {
          final municipality = municipalities[index];
          return GestureDetector(
            onTap: () async {
              Get.showOverlay(
                asyncFunction: () async {

                  Get.lazyPut(() => PropertyController());

                  await widget.municipalityController.cacheMunicipality(municipality);

                  Get.offAll(() => const HomeScreen());
                },
                loadingWidget: const Center(
                  child: CustomLoader(
                    message: 'Please wait',
                  ),
                ),
              );
            },
            child: ListTile(
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
            ),
          );
        },
      ),
    );
  }
}
