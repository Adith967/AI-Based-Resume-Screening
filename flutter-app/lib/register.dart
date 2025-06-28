import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:io';

import 'login.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(32, 63, 129, 1.0),
        ),
      ),
      home: const RegMain(),
    );
  }
}

class RegMain extends StatefulWidget {
  const RegMain({Key? key}) : super(key: key);

  @override
  State<RegMain> createState() => _RegMainState();
}


class _RegMainState extends State<RegMain> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController expController = TextEditingController();
  final TextEditingController skillController = TextEditingController();

  File? _selectedImage;
  String? _encodedImage;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
        backgroundColor: Colors.blue, // Set AppBar background color to blue
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              _buildTextField(nameController, 'Name', Icons.person_outline),
              const SizedBox(height: 10),
              _buildTextField(emailController, 'Email', Icons.email, TextInputType.emailAddress),
              const SizedBox(height: 10),
              _buildTextField(phoneController, 'Phone', Icons.phone, TextInputType.number),

              const SizedBox(height: 10),
              _buildTextField(expController, 'Experience', Icons.expand_more, TextInputType.number),


                 const SizedBox(height: 10),
              _buildTextField(skillController, 'Skill', Icons.work), const SizedBox(height: 10),
   const SizedBox(height: 10),
              _buildTextField(educationController, 'Education', Icons.cast_for_education), const SizedBox(height: 10),


              const SizedBox(height: 10),
              _buildPasswordField(),
              const SizedBox(height: 60),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _sendData();
                  }
                },
                child: const Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildTextField(TextEditingController controller, String label, [IconData? icon, TextInputType inputType = TextInputType.text]) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter $label.';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.password_outlined),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.length < 8) return 'Please enter a password of at least 8 characters.';
        return null;
      },
    );
  }



  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text('Please grant permission to choose an image.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


  Future<void> _sendData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? url = prefs.getString('url');
    if (url != null) {
      final Uri apiUri = Uri.parse('$url/user_reg');
      try {
        final response = await http.post(apiUri, body: {
          'full_name': nameController.text,
          'email': emailController.text,
          'contact_no': phoneController.text,
          'education': educationController.text,
          'exp': expController.text,
          'password': passwordController.text,
          'skill': skillController.text,
        });

        if (response.statusCode == 200) {
          final String status = jsonDecode(response.body)['status'];
          if (status == 'ok') {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Login(),)

            );
            Fluttertoast.showToast(msg: 'Registration Successful');

          } else {
            Fluttertoast.showToast(msg: 'Username Already taken');
          }
        } else {
          Fluttertoast.showToast(msg: 'Network Error');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error: $e');
      }
    }
  }
}
