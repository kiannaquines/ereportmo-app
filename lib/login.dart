import 'dart:async';
import 'dart:convert';

import 'package:ereportmo_app/constants.dart';
import 'package:ereportmo_app/dashboard.dart';
import 'package:ereportmo_app/includes/app_fonts.dart';
import 'package:ereportmo_app/includes/ereportmo_shared.dart';
import 'package:ereportmo_app/includes/ui_shell.dart';
import 'package:ereportmo_app/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.title = 'Login Account'});

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isProcessing = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppCanvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: appScreenPadding(context),
          child: buildScreenPanel(
            context: context,
            children: [
              buildProgressBar(context, 0.35),
              const SizedBox(height: 28),
              buildScreenHeader(
                context,
                title: 'Welcome Back',
                subtitle:
                    'Sign in to continue managing reports and community updates from your account.',
              ),
              const SizedBox(height: 28),
              buildSectionLabel('Account Details'),
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
                obscureText: _obscurePassword,
                trailing: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF7C8596),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: isProcessing ? null : _handleLogin,
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
                          : const Text('Login'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.inter(color: kAppMutedText),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text('Sign up'),
                    ),
                  ],
                ),
              ),
            ],
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
    bool obscureText = false,
    Widget? trailing,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      isProcessing = true;
    });
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      setState(() {
        isProcessing = false;
      });
      return;
    }

    final response = await http.post(
      Uri.parse('$baseApiUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    final Map<String, dynamic> responseMessage = jsonDecode(response.body);
    final String message = responseMessage['message'] ?? 'Login failed';

    if (!mounted) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      await saveLoginData(
        responseData['access_token'],
        responseData['user']['name'],
      );
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(message)));
      _emailController.clear();
      _passwordController.clear();
      setState(() {
        isProcessing = false;
      });
      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      });
    } else {
      messenger.showSnackBar(SnackBar(content: Text(message)));
      setState(() {
        isProcessing = false;
      });
    }
  }
}
