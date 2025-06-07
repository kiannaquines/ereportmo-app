import 'dart:convert';

import 'package:ereportmo_app/constants.dart';
import 'package:ereportmo_app/dashboard.dart';
import 'package:ereportmo_app/register.dart';
import 'package:flutter/material.dart';
import 'package:ereportmo_app/includes/appbar.dart';
import 'package:ereportmo_app/includes/ereportmo_shared.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

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

  void _handleLogin() async {
    setState(() {
      isProcessing = true;
    });
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      setState(() {
        isProcessing = false;
      });
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      setState(() {
        isProcessing = false;
      });
      return;
    }

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 8 characters long'),
        ),
      );
      setState(() {
        isProcessing = false;
      });
      return;
    }

    if (password.contains(' ')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password cannot contain spaces')),
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
    String message = responseMessage['message'] ?? 'Login failed';

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['access_token'];
      final name = responseData['user']['name'];

      await saveLoginData(token, name);

      //   show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(fontFamily: GoogleFonts.openSans().fontFamily),
          ),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
            },
          ),
        ),
      );

      //   clear input fields
      _emailController.clear();
      _passwordController.clear();

      setState(() {
        isProcessing = false;
      });

      //   navigate to dashboard
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      });
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(fontFamily: GoogleFonts.openSans().fontFamily),
          ),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
            },
          ),
        ),
      );
      setState(() {
        isProcessing = false;
      });
    } else if (response.statusCode == 422) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(fontFamily: GoogleFonts.openSans().fontFamily),
          ),
        ),
      );
      setState(() {
        isProcessing = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(fontFamily: GoogleFonts.openSans().fontFamily),
          ),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
            },
          ),
        ),
      );
      setState(() {
        isProcessing = false;
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
        child: EReportModeAppBar(withBackButton: false, title: "Login Account"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    fontFamily: GoogleFonts.openSans().fontFamily,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Login to your account to continue.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontFamily: GoogleFonts.openSans().fontFamily,
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  color: Colors.white,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Account Information",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color:
                                    Colors
                                        .grey
                                        .shade200, // Border color when NOT focused
                                width: 1.5,
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
                          controller: _passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outlined),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color:
                                    Colors
                                        .grey
                                        .shade200, // Border color when NOT focused
                                width: 1.5,
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
                      ],
                    ),
                  ),
                ),

                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child:
                        isProcessing
                            ? const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                        fontFamily: GoogleFonts.openSans().fontFamily,
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      child: Text(
                        "Click here",
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontFamily: GoogleFonts.openSans().fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
