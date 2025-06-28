import 'dart:io';
import 'package:airesume/resume%20upload.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'home.dart';

void main() {
  runApp(const ResumeApp());
}

class ResumeApp extends StatelessWidget {
  const ResumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resume Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _resumeFile;
  String? _fileName;

  // Function to pick and upload resume
  Future<void> _uploadResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;

      setState(() {
        _resumeFile = File(file.path!);
        _fileName = file.name;
      });

      // Save the file to app directory
      final newFile = await _resumeFile!.copy('$path/$_fileName');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resume uploaded successfully!')),
      );
    }
  }

  // Function to view resume
  void _viewResume() {
    if (_resumeFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResumeViewPage(file: _resumeFile!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a resume first')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Manager'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => JobFinderHomePage(),));
              },
              child: const Text('Upload Resume'),
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 20),
            if (_fileName != null)
              Text(
                'Current Resume: $_fileName',
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}

// Separate page for viewing resume
class ResumeViewPage extends StatelessWidget {
  final File file;

  const ResumeViewPage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Viewer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Resume Preview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'File path: ${file.path}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Note: This is a basic preview. For actual PDF viewing, add a PDF viewer package.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}