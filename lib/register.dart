import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:ereportmo_app/login.dart';
import 'package:flutter/material.dart';
import 'includes/appbar.dart';
import 'package:drop_down_list/drop_down_list.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.title = 'Register Account'});

  final String title;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _barangayController = TextEditingController();
  final TextEditingController _municipalityController = TextEditingController();
  final List<String> _listOfMunicipalities = [
    'Alamada',
    'Aleosan',
    'Antipas',
    'Arakan',
    'Banisilan',
    'Carmen',
    'Kabacan',
    'Libungan',
    'Magpet',
    'Makilala',
    'Matalam',
    'M\'lang',
    'Midsayap',
    'Pigcawayan',
    'Pikit',
    'President Roxas',
    'Tulunan',
    'Kidapawan City',
  ];

  void _handleRegister() {
    final name = _nameController.text;
    final email = _emailController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final barangay = _barangayController.text;
    final municipality = _municipalityController.text;

    // Replace this with your actual API call
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Registering: $username')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: EReportModeAppBar(
          withBackButton: false,
          title: 'Register Account',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Get started by creating an account.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 32),
              const Text("Personal Information"),
              const SizedBox(height: 16),
              // Name field
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
                        "Personal Information",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          prefixIcon: Icon(Icons.person_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _municipalityController,
                        readOnly: true,
                        onTap: onMunicipalityTextFieldTap,
                        decoration: const InputDecoration(
                          labelText: 'Municipality',
                          hintText: 'Select your municipality',
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _barangayController,
                        decoration: const InputDecoration(
                          labelText: 'Barangay',
                          hintText: 'Enter your barangay',
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter your username',
                          prefixIcon: Icon(Icons.account_circle_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Enter your password again',
                          prefixIcon: Icon(Icons.lock_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Register button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Register',
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
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder:
                              (context) => const LoginScreen(title: 'Login'),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                    ),
                    child: Text(
                      "Login here",
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onMunicipalityTextFieldTap() {
    DropDownState<String>(
      dropDown: DropDown<String>(
        isDismissible: true,
        enableMultipleSelection: false, // Only allow single selection
        bottomSheetTitle: const Text(
          'Select Municipality',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        dropDownBackgroundColor: Colors.white,
        submitButtonText: 'Save',
        clearButtonText: 'Clear',
        data:
            _listOfMunicipalities
                .map(
                  (municipality) =>
                      SelectedListItem<String>(data: municipality),
                )
                .toList(),
        onSelected: (selectedItems) {
          if (selectedItems.isNotEmpty) {
            // Set the selected item to the text controller
            setState(() {
              _municipalityController.text = selectedItems.first.data;
            });
          }
        },
      ),
    ).showModal(context);
  }
}
