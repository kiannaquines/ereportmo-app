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

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

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
        'incident_id': _selectedIncidentTypeId, // Ensure this is an int
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
        backgroundColor: Colors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: EReportModeAppBar(withBackButton: true, title: widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report Incident',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.openSans().fontFamily,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Report the incident you have witnessed',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: GoogleFonts.openSans().fontFamily,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Reported Incident Information",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            controller: _incidentTypeController,
                            readOnly: true,
                            onTap: onIncidentTypeTextFieldTap,
                            decoration: InputDecoration(
                              labelText: 'Incident Type',
                              prefixIcon: Icon(Icons.location_on_outlined),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            maxLines: 5,
                            controller: _incidentDescriptionController,
                            decoration: InputDecoration(
                              labelText: 'Incident Description',
                              prefixIcon: Icon(Icons.description_outlined),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Attach Photo',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                  fontFamily: GoogleFonts.openSans().fontFamily,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed:
                                        () => _pickImage(ImageSource.camera),
                                    icon: Icon(Icons.camera_alt_outlined),
                                    label: Text(
                                      "Camera",
                                      style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.openSans().fontFamily,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          theme.colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      elevation: 1,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 5,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed:
                                        () => _pickImage(ImageSource.gallery),
                                    icon: Icon(Icons.photo_library_outlined),
                                    label: Text(
                                      "Gallery",
                                      style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.openSans().fontFamily,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          theme.colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      elevation: 1,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (_selectedImage != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    _selectedImage!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _latitudeController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Latitude',
                              prefixIcon: Icon(Icons.location_on_outlined),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _longitudeController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Longitude',
                              prefixIcon: Icon(Icons.location_on_outlined),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleReportIncident,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
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
                              : const Text(
                                'Report Incident',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  void onIncidentTypeTextFieldTap() async {
    if (!_incidentTypesCached) {
      final fetchedIncidentType = await fetchIncidentTypes();
      setState(() {
        _listOfIncidentTypes.clear();
        _listOfIncidentTypes.addAll(fetchedIncidentType);
        _incidentTypesCached = true; // mark cache as populated
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
        submitButtonText: 'Save',
        clearButtonText: 'Clear',
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
}
