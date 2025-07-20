import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:ereportmo_app/constants.dart';
import 'package:ereportmo_app/models/incident.dart';
import 'package:flutter/material.dart';
import 'package:ereportmo_app/includes/appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ereportmo_app/includes/ereportmo_shared.dart';
import 'package:location/location.dart';
import 'package:dio/dio.dart';

class ReportIncident extends StatefulWidget {
  const ReportIncident({super.key, required this.title});

  final String title;

  @override
  State<ReportIncident> createState() => _ReportIncidentState();
}

class _ReportIncidentState extends State<ReportIncident> {
  final List<IncidentType> _listOfIncidentTypes = [];
  int? _selectedIncidentTypeId;
  bool _incidentTypesCached = false;
  final TextEditingController _incidentTypeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _incidentDescriptionController =
      TextEditingController();

  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  void getCurrentLocation() async {
    final location = Location();
    location.enableBackgroundMode(enable: true);

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      _latitudeController.text = currentLocation.latitude.toString();
      _longitudeController.text = currentLocation.longitude.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void onIncidentTypeTextFieldTap() async {
    if (!_incidentTypesCached) {
      final fetchedIncidentType = await fetchIncidentTypes();
      setState(() {
        _listOfIncidentTypes.clear();
        _listOfIncidentTypes.addAll(fetchedIncidentType);
        _incidentTypesCached = true;
      });
    }

    DropDownState<String>(
      dropDown: DropDown<String>(
        isDismissible: true,
        enableMultipleSelection: false,
        bottomSheetTitle: const Text(
          'Select Incident Type',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        dropDownBackgroundColor: Colors.white,
        data:
            _listOfIncidentTypes
                .map(
                  (incidentType) => SelectedListItem<String>(
                    data:
                        '${incidentType.office.office} - ${incidentType.incident}',
                  ),
                )
                .toList(),
        onSelected: (selectedItems) {
          if (selectedItems.isNotEmpty) {
            final selectedIncidentTypeName = selectedItems.first.data;
            final selectedIncidentType = _listOfIncidentTypes.firstWhere(
              (incidentType) =>
                  '${incidentType.office.office} - ${incidentType.incident}' ==
                  selectedIncidentTypeName,
            );

            setState(() {
              _incidentTypeController.text = selectedIncidentType.incident;
              _selectedIncidentTypeId = selectedIncidentType.id;
            });
          }
        },
      ),
    ).showModal(context);
  }

  Future<List<IncidentType>> fetchIncidentTypes() async {
    final token = await getSecureToken();
    final response = await http.get(
      Uri.parse('$baseApiUrl/incident-types'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final incidentTypeResponse = IncidentTypeResponse.fromJson(data);
      return incidentTypeResponse.incidentTypes;
    } else {
      throw Exception('Failed to load incident types');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _handleReportIncident() async {
    final theme = Theme.of(context);
    setState(() {
      _isProcessing = true;
    });

    try {
      final token = await getSecureToken();

      final dio = Dio();
      dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      };

      if (_selectedIncidentTypeId == null) {
        _showErrorSnackBar('Please select an incident type');
        return;
      }

      if (_incidentDescriptionController.text.isEmpty) {
        _showErrorSnackBar('Please enter an incident description');
        return;
      }

      if (_latitudeController.text.isEmpty) {
        _showErrorSnackBar('Please enter a latitude');
        return;
      }

      if (_selectedImage == null) {
        _showErrorSnackBar('Please select an image');
        return;
      }

      if (_longitudeController.text.isEmpty) {
        _showErrorSnackBar('Please enter a longitude');
        return;
      }
      final formData = FormData.fromMap({
        'incident_id': _selectedIncidentTypeId,
        'description': _incidentDescriptionController.text,
        'latitude': _latitudeController.text,
        'longitude': _longitudeController.text,
        if (_selectedImage != null)
          'image': await MultipartFile.fromFile(
            _selectedImage!.path,
            filename: _selectedImage!.path.split('/').last,
          ),
      });

      final response = await dio.post(
        '$baseApiUrl/report-incident',
        data: formData,
      );

      final responseData =
          response.data is String ? jsonDecode(response.data) : response.data;

      final message =
          responseData['message'] ?? 'Incident report response received.';

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: TextStyle(
                fontFamily: GoogleFonts.openSans().fontFamily,
                fontSize: 16,
              ),
            ),
            backgroundColor: theme.colorScheme.primary,
          ),
        );

        _incidentTypeController.clear();
        _incidentDescriptionController.clear();
        _latitudeController.clear();
        _longitudeController.clear();

        setState(() {
          _selectedImage = null;
          _selectedIncidentTypeId = null;
        });
      } else {
        _showErrorSnackBar(message);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        final message =
            responseData['message'] ??
            'Something went wrong. Please try again.';

        if (responseData['errors'] != null) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          final errorMessages = errors.entries
              .map((entry) => '${entry.key}: ${entry.value.join(', ')}')
              .join('\n');

          _showErrorSnackBar(errorMessages);
        } else {
          _showErrorSnackBar(message);
        }
      } else {
        _showErrorSnackBar("Network error. Please try again.");
      }
    } catch (e) {
      _showErrorSnackBar("An unexpected error occurred. Please try again.");
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: GoogleFonts.openSans().fontFamily,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: EReportModeAppBar(
          withBackButton: true,
          title: widget.title,
          withActionButtons: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report Incident',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Provide details about the incident you witnessed',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Incident Details",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _incidentTypeController,
                      readOnly: true,
                      onTap: onIncidentTypeTextFieldTap,
                      decoration: InputDecoration(
                        labelText: 'Incident Type',
                        labelStyle: GoogleFonts.poppins(
                          color: Colors.grey[600],
                        ),
                        hintText: 'Select incident type',
                        prefixIcon: Icon(
                          Icons.warning_amber_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      maxLines: 5,
                      minLines: 3,
                      controller: _incidentDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'Incident Description',
                        labelStyle: GoogleFonts.poppins(
                          color: Colors.grey[600],
                        ),
                        hintText: 'Describe what happened...',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(
                          Icons.description_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attach Photo Evidence',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Take a photo or select from gallery',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _pickImage(ImageSource.camera),
                                icon: const Icon(Icons.camera_alt_outlined),
                                label: const Text("Camera"),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  side: BorderSide(
                                    color: colorScheme.primary.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed:
                                    () => _pickImage(ImageSource.gallery),
                                icon: const Icon(Icons.photo_library_outlined),
                                label: const Text("Gallery"),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  side: BorderSide(
                                    color: colorScheme.primary.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (_selectedImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                Image.file(
                                  _selectedImage!,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _selectedImage = null;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Incident Location',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _latitudeController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Latitude',
                              labelStyle: GoogleFonts.poppins(
                                color: Colors.grey[600],
                              ),
                              prefixIcon: Icon(
                                Icons.location_on_outlined,
                                color: theme.colorScheme.primary,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _longitudeController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Longitude',
                              labelStyle: GoogleFonts.poppins(
                                color: Colors.grey[600],
                              ),
                              prefixIcon: Icon(
                                Icons.location_on_outlined,
                                color: theme.colorScheme.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Location is automatically detected',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleReportIncident,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child:
                    _isProcessing
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Text(
                          'Submit Report',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
