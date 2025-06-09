import 'package:dio/dio.dart';
import 'package:ereportmo_app/constants.dart';
import 'package:ereportmo_app/detail.dart';
import 'package:ereportmo_app/includes/utils.dart';
import 'package:ereportmo_app/models/report.dart';
import 'package:flutter/material.dart';
import 'package:ereportmo_app/includes/appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ereportmo_app/includes/ereportmo_shared.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, this.title = 'Report History List'});

  final String title;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<ReportedIncident> reports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    final token = await getSecureToken();
    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Accept'] = 'application/json';

      final response = await dio.get('$baseApiUrl/my-reported-incidents');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<ReportedIncident> fetchedReports =
            data.map((json) => ReportedIncident.fromJson(json)).toList();

        setState(() {
          reports = fetchedReports;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: EReportModeAppBar(
          withBackButton: true,
          title: widget.title,
          withActionButtons: true,
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EReportMo Report History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.openSans().fontFamily,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'This is your report history. You can see the status of your report here.',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: GoogleFonts.openSans().fontFamily,
                          color: Colors.grey.shade700,
                        ),
                      ),

                      ListView.builder(
                        itemCount: reports.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final report = reports[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 0,
                              child: ListTile(
                                leading: const Icon(Icons.report),
                                title: Text(
                                  report.incident.incident,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                subtitle: Text(
                                  formatReadableDate(report.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily:
                                        GoogleFonts.openSans().fontFamily,
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        report.incidentResponseStatus == 'New'
                                            ? Colors.yellow.shade200
                                            : report.incidentResponseStatus ==
                                                'Assigned'
                                            ? Colors.blue.shade200
                                            : report.incidentResponseStatus ==
                                                'In Progress'
                                            ? Colors.orange.shade200
                                            : report.incidentResponseStatus ==
                                                'Resolved'
                                            ? Colors.green.shade200
                                            : Colors.red.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    report.incidentResponseStatus,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          report.incidentResponseStatus == 'New'
                                              ? Colors.yellow.shade800
                                              : report.incidentResponseStatus ==
                                                  'Assigned'
                                              ? Colors.blue.shade800
                                              : report.incidentResponseStatus ==
                                                  'In Progress'
                                              ? Colors.orange.shade800
                                              : report.incidentResponseStatus ==
                                                  'Resolved'
                                              ? Colors.green.shade800
                                              : report.incidentResponseStatus ==
                                                  'Closed'
                                              ? Colors.red.shade800
                                              : Colors.grey,
                                      fontFamily:
                                          GoogleFonts.openSans().fontFamily,
                                    ),
                                  ),
                                ),
                                onTap: () {},
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
