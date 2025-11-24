import 'dart:convert';

import 'package:ereportmo_app/constants.dart';
import 'package:ereportmo_app/includes/appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer 123',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        final List<dynamic>? arr = jsonBody['municipalities'];
        if (arr != null) {
          setState(() {
            _municipalities = arr.cast<String>().toList();
          });
        } else {
          setState(() {
            _error = 'Malformed server response';
          });
        }
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: EReportModeAppBar(
          withBackButton: true,
          title: 'Supported Municipalities',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Municipalities supported by this app',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Below is a list of municipalities currently supported by the application. Contact the administrator to request additions.',
                style: GoogleFonts.poppins(color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),

              // Search box
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search municipalities',
                    prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchMunicipalities,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _error != null
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(_error!, style: GoogleFonts.poppins()),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: _fetchMunicipalities,
                                        child: Text('Retry', style: GoogleFonts.poppins()),
                                      ),
                                    ],
                                  ),
                                )
                              : _municipalities.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.location_off, size: 56, color: Colors.grey.shade400),
                                          const SizedBox(height: 8),
                                          Text('No municipalities available', style: GoogleFonts.poppins(color: Colors.grey[600])),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      itemCount: _municipalities.where((m) => m.toLowerCase().contains(_searchController.text.toLowerCase())).length,
                                      separatorBuilder: (_, __) => const Divider(height: 1),
                                      itemBuilder: (context, index) {
                                        final filtered = _municipalities.where((m) => m.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
                                        final item = filtered[index];
                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                                            child: Icon(Icons.location_city, color: theme.colorScheme.primary),
                                          ),
                                          title: Text(item, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                          subtitle: Text('Supported', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                                          trailing: const Icon(Icons.chevron_right),
                                          onTap: () {},
                                        );
                                      },
                                    ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
