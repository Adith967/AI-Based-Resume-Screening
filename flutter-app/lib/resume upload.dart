import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:file_picker/file_picker.dart'; // Replace image_picker with file_picker

import '../login.dart';

class Resumes extends StatefulWidget {
  const Resumes({Key? key}) : super(key: key);

  @override
  State<Resumes> createState() => _ResumesState();
}

class _ResumesState extends State<Resumes> {
  bool _obscurePassword = true;
  File? _resumeFile; // Change from XFile to File for PDF
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              Text(
                "Upload Resume",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              SizedBox(height: 30),
              _buildFilePicker(
                title: "Upload PDF Resume",
                onFilePick: _pickResumeFile,
                selectedFile: _resumeFile,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method: Build file picker for PDF
  Widget _buildFilePicker({
    required String title,
    required Function() onFilePick,
    required File? selectedFile,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: onFilePick,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[700]!, width: 2),
            ),
            child: selectedFile != null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.picture_as_pdf,
                  size: 40,
                  color: Colors.red,
                ),
                SizedBox(height: 8),
                Text(
                  "PDF Selected",
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
                : Icon(
              Icons.upload_file,
              size: 40,
              color: Colors.blue[700],
            ),
          ),
        ),
      ],
    );
  }

  // Method: Handle PDF file pick
  Future<void> _pickResumeFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Restrict to PDF files only
    );

    if (result != null) {
      setState(() {
        _resumeFile = File(result.files.single.path!);
      });
    }
  }

  // Method: Handle user registration
  Future<void> _registerUser() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      String url = prefs.getString("url") ?? '';
      String lid = prefs.getString("lid") ?? '';
      String jid = prefs.getString("jid") ?? '';

      var request = http.MultipartRequest('POST', Uri.parse('$url/user_upload_file'));
      request.fields.addAll({
        'lid': lid,
        'jid': jid,
      });

      if (_resumeFile != null) {
        request.files.add(await http.MultipartFile.fromPath('file', _resumeFile!.path));
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        _showSnackBar("Successful");
      } else {
        _showSnackBar("Failed");
      }
    } catch (e) {
      _showSnackBar("An error occurred: $e");
    }
    setState(() => _isLoading = false);
  }

  // Helper method: Show snack bar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}