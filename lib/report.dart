import 'package:dio/dio.dart';
import 'package:ereportmo_app/constants.dart';
import 'package:ereportmo_app/includes/app_fonts.dart';
import 'package:ereportmo_app/includes/ereportmo_shared.dart';
import 'package:ereportmo_app/includes/ui_shell.dart';
import 'package:ereportmo_app/includes/utils.dart';
import 'package:ereportmo_app/models/report.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, this.title = 'Report History'});

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
    _fetchReports();
  }

  Future<void> deleteReport(String id) async {
    try {
      final token = await getSecureToken();
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Accept'] = 'application/json';

      final response = await dio.delete('$baseApiUrl/report-incident/$id');

      if (response.statusCode == 200) {
        await _fetchReports();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report deleted successfully')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete report: ${e.toString()}')),
      );
    }
  }

  Future<void> _fetchReports() async {
    final token = await getSecureToken();
    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Accept'] = 'application/json';

      final response = await dio.get('$baseApiUrl/my-reported-incidents');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final fetchedReports =
            data.map((json) => ReportedIncident.fromJson(json)).toList();
        if (mounted) {
          setState(() {
            reports = fetchedReports;
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppCanvas,
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: kAppAccent),
              )
              : RefreshIndicator(
                onRefresh: _fetchReports,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: appScreenPadding(context),
                  child: buildScreenPanel(
                    context: context,
                    children: [
                      buildScreenHeader(
                        context,
                        title: 'Report History',
                        subtitle:
                            'Review the status of every incident you have already submitted.',
                        showBackButton: true,
                      ),
                      const SizedBox(height: 24),
                      if (reports.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 40,
                          ),
                          decoration: appSoftCardDecoration(),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.assignment_outlined,
                                size: 56,
                                color: Color(0xFFC8B9AF),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'No reports found',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: kAppTitleText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (reports.isNotEmpty)
                        ...reports.map(
                          (report) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _buildReportCard(context, report),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildReportCard(BuildContext context, ReportedIncident report) {
    final statusColor = _getStatusColor(report.incidentResponseStatus);
    final statusTextColor = _getStatusTextColor(report.incidentResponseStatus);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _showDeleteConfirmation(context, report.id.toString()),
        child: Ink(
          decoration: appSoftCardDecoration(),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      report.incident.incident,
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: kAppTitleText,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      report.incidentResponseStatus,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: statusTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                formatReadableDate(report.createdAt),
                style: GoogleFonts.inter(fontSize: 13, color: kAppMutedText),
              ),
              if (report.description != null && report.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    report.description!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.5,
                      color: kAppLabelText,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'New':
        return Colors.amber;
      case 'Assigned':
        return const Color(0xFF67A4F8);
      case 'In Progress':
        return const Color(0xFFF59D3D);
      case 'Resolved':
        return const Color(0xFF4CAF7D);
      case 'Closed':
        return kAppAccent;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'New':
        return Colors.amber.shade900;
      case 'Assigned':
        return const Color(0xFF2F6ABC);
      case 'In Progress':
        return const Color(0xFF9E5A04);
      case 'Resolved':
        return const Color(0xFF1E6C4A);
      case 'Closed':
        return const Color(0xFF9C3419);
      default:
        return Colors.grey.shade800;
    }
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delete report',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: kAppTitleText,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Are you sure you want to delete this report?',
                  style: GoogleFonts.inter(color: kAppMutedText, height: 1.5),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(color: kAppMutedText),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        deleteReport(id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAppAccent,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
