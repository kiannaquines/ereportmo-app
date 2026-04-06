import 'dart:convert';

import 'package:ereportmo_app/constants.dart';
import 'package:ereportmo_app/includes/app_fonts.dart';
import 'package:ereportmo_app/includes/ui_shell.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MunicipalitiesScreen extends StatefulWidget {
  const MunicipalitiesScreen({super.key});

  @override
  State<MunicipalitiesScreen> createState() => _MunicipalitiesScreenState();
}

class _MunicipalitiesScreenState extends State<MunicipalitiesScreen> {
  List<String> _municipalities = [];
  bool _isLoading = false;
  String? _error;
  final TextEditingController _searchController = TextEditingController();

  List<String> get _filteredMunicipalities {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _municipalities;
    return _municipalities
        .where((item) => item.toLowerCase().contains(query))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchMunicipalities();
  }

  Future<void> _fetchMunicipalities() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$baseApiUrl/locations'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        final List<dynamic>? arr = jsonBody['municipalities'];
        setState(() {
          _municipalities = arr?.cast<String>().toList() ?? [];
        });
      } else {
        setState(() {
          _error = 'Failed to load municipalities';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredMunicipalities;

    return Scaffold(
      backgroundColor: kAppCanvas,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchMunicipalities,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: appScreenPadding(context),
            child: buildScreenPanel(
              context: context,
              children: [
                buildScreenHeader(
                  context,
                  title: 'Supported Areas',
                  subtitle:
                      'Search the municipalities currently available in the reporting system.',
                  showBackButton: true,
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: kAppAccentSoft,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.location_city_outlined,
                          color: kAppAccent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${_municipalities.length} municipalities available',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: kAppTitleText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _searchController,
                  decoration: appInputDecoration(
                    context,
                    label: 'Search municipalities',
                    icon: Icons.search_rounded,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(color: kAppAccent),
                    ),
                  )
                else if (_error != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: appSoftCardDecoration(),
                    child: Column(
                      children: [
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(color: kAppMutedText),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _fetchMunicipalities,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                else if (filtered.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: appSoftCardDecoration(),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.location_off_outlined,
                          size: 48,
                          color: Color(0xFFC8B9AF),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No municipalities match your search',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: kAppTitleText,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...filtered.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: appSoftCardDecoration(),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: kAppAccentSoft,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.place_outlined,
                                color: kAppAccent,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: kAppTitleText,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Supported municipality',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: kAppMutedText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: kAppMutedText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
