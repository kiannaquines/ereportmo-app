import 'dart:async';
import 'dart:convert';

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:ereportmo_app/constants.dart';
import 'package:ereportmo_app/includes/app_fonts.dart';
import 'package:ereportmo_app/includes/ui_shell.dart';
import 'package:ereportmo_app/login.dart';
import 'package:ereportmo_app/municipalities.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.title = 'Register Account'});

  final String title;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _barangayController = TextEditingController();
  final TextEditingController _municipalityController = TextEditingController();
  bool isProcessing = false;
  List<String> _listOfMunicipalities = [];
  bool _isFetchingMunicipalities = false;
  String? _municipalitiesError;

  @override
  void initState() {
    super.initState();
    fetchMunicipalities();
  }

  Future<void> fetchMunicipalities() async {
    setState(() {
      _isFetchingMunicipalities = true;
      _municipalitiesError = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$baseApiUrl/locations'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        final List<dynamic>? municipalitiesJson = jsonBody['municipalities'];
        if (municipalitiesJson != null) {
          setState(() {
            _listOfMunicipalities = municipalitiesJson.cast<String>().toList();
          });
        } else {
          setState(() {
            _municipalitiesError = 'Malformed response from server';
          });
        }
      } else {
        setState(() {
          _municipalitiesError = 'Failed to load municipalities';
        });
      }
    } catch (e) {
      setState(() {
        _municipalitiesError = e.toString();
      });
    } finally {
      setState(() {
        _isFetchingMunicipalities = false;
      });
    }
  }

  void _handleRegister() async {
    setState(() {
      isProcessing = true;
    });
    final response = await http.post(
      Uri.parse('$baseApiUrl/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': _nameController.text,
        'email': _emailController.text,
        'municipality': _municipalityController.text,
        'barangay': _barangayController.text,
        'password': _passwordController.text,
        'password_confirmation': _confirmPasswordController.text,
      }),
    );

    final Map<String, dynamic> responseMessage = jsonDecode(response.body);
    final String message = responseMessage['message'] ?? 'Registration failed';
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    if (response.statusCode == 201) {
      _passwordController.clear();
      _confirmPasswordController.clear();
      _emailController.clear();
      _nameController.clear();
      _barangayController.clear();
      _municipalityController.clear();
      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    } else {
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppCanvas,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchMunicipalities,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: appScreenPadding(context),
            child: buildScreenPanel(
              context: context,
              children: [
                buildProgressBar(context, 0.55),
                const SizedBox(height: 28),
                buildScreenHeader(
                  context,
                  title: 'Create your account',
                  subtitle:
                      'Enter your details so we can personalize your reporting experience.',
                ),
                const SizedBox(height: 28),
                buildSectionLabel('Personal Information'),
                const SizedBox(height: 14),
                _buildInputField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 14),
                _buildInputField(
                  controller: _municipalityController,
                  label: 'Municipality',
                  icon: Icons.location_on_outlined,
                  readOnly: true,
                  onTap: onMunicipalityTextFieldTap,
                  trailing:
                      _isFetchingMunicipalities
                          ? SizedBox(
                            width: 18,
                            height: 18,
                            child: Padding(
                              padding: const EdgeInsets.all(13),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          )
                          : const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: kAppMutedText,
                          ),
                ),
                if (_municipalitiesError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _municipalitiesError!,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.red.shade400,
                    ),
                  ),
                ],
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MunicipalitiesScreen(),
                        ),
                      );
                    },
                    child: const Text('View supported municipalities'),
                  ),
                ),
                _buildInputField(
                  controller: _barangayController,
                  label: 'Barangay',
                  icon: Icons.map_outlined,
                ),
                const SizedBox(height: 24),
                buildSectionLabel('Account Information'),
                const SizedBox(height: 14),
                _buildInputField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.alternate_email_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                _buildInputField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline_rounded,
                  obscureText: true,
                ),
                const SizedBox(height: 14),
                _buildInputField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  icon: Icons.verified_user_outlined,
                  obscureText: true,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: isProcessing ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAppAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child:
                        isProcessing
                            ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                            : const Text('Next'),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: GoogleFonts.inter(color: kAppMutedText),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text('Sign in'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
    bool obscureText = false,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      obscureText: obscureText,
      onTap: onTap,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: kAppTitleText,
      ),
      decoration: appInputDecoration(
        context,
        label: label,
        icon: icon,
        trailing: trailing,
      ),
    );
  }

  void onMunicipalityTextFieldTap() {
    if (_isFetchingMunicipalities || _listOfMunicipalities.isEmpty) return;
    DropDownState<String>(
      dropDown: DropDown<String>(
        bottomSheetTitle: Text(
          'Municipalities',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        data:
            _listOfMunicipalities
                .map(
                  (municipality) =>
                      SelectedListItem<String>(data: municipality),
                )
                .toList(),
        onSelected: (selectedItems) {
          final selectedMunicipality = selectedItems.first.data;
          _municipalityController.text = selectedMunicipality;
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _barangayController.dispose();
    _municipalityController.dispose();
    super.dispose();
  }
}
