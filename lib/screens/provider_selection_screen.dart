import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../models/utility_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/utility_provider_provider.dart';

class UtilityProviderSelectionScreen extends StatefulWidget {
  const UtilityProviderSelectionScreen({super.key});

  @override
  State<UtilityProviderSelectionScreen> createState() =>
      _UtilityProviderSelectionScreenState();
}

class _UtilityProviderSelectionScreenState
    extends State<UtilityProviderSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UtilityProviderProvider>(context, listen: false)
          .fetchProviders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final municipalityProvider = Provider.of<UtilityProviderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130,
        title: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                    themeProvider.isDarkMode
                        ? "assets/logo-white.svg"
                        : "assets/logo.svg",
                    height: 30
                ),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 45,
              child: TextField(
                controller: _searchController,
                onChanged: (query) =>
                    municipalityProvider.filterProviders(query),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SvgPicture.asset(
                      "assets/icons/search.svg",
                      width: 20,
                      height: 20,
                    ),
                  ),
                  hintText: "Search providers",
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: municipalityProvider.providers.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: municipalityProvider.providers.length,
                    itemBuilder: (context, index) {
                      final UtilityProvider municipality =
                          municipalityProvider.providers[index];
                      return GestureDetector(
                        onTap: () async {
                          const routeName = '/home';
                          await municipalityProvider
                              .selectUtilityProvider(municipality);
                          if (!mounted) return;
                          Navigator.pushReplacementNamed(context, routeName);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 12, left: 16, right: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          decoration: BoxDecoration(
                            color: themeProvider.isDarkMode
                                ? Colors.grey.shade900
                                : Colors.white,
                            border: Border.all(
                                color: themeProvider.isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                                width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                            title: Text(
                              municipality.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
