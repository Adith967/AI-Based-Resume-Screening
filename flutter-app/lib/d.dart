//
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
//
// import '../login.dart';
//
// class UploadResume extends StatefulWidget {
//   const UploadResume({Key? key}) : super(key: key);
//
//   @override
//   State<UploadResume> createState() => _UploadResumeState();
// }
//
// class _UploadResumeState extends State<UploadResume> {
//   // Controllers for user input fields
//   final TextEditingController par_skillsController = TextEditingController();
//   final TextEditingController exp_yrController = TextEditingController();
//   final TextEditingController educationController = TextEditingController();
//   final TextEditingController job_roleController = TextEditingController();
//
//
//   // State variables
//   bool _obscurePassword = true;
//   XFile? _profileImage;
//   XFile? _idProofImage;
//   bool _isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               SizedBox(height: 20),
//               // Logo and Title
//
//               SizedBox(height: 30),
//               // ID Proof
//               _buildImagePicker(
//                 title: "ID Proof",
//                 onImagePick: _pickIdProofImage,
//                 selectedImage: _idProofImage,
//               ),
//               SizedBox(height: 30),
//               // Personal Information
//               _buildSectionTitle("Resume Information"),
//               SizedBox(height: 16),
//               _buildTextField(
//                 controller: par_skillsController,
//                 label: "Skills",
//                 icon: Icons.person_outline,
//               ),
//               SizedBox(height: 16),
//               _buildTextField(
//                 controller: exp_yrController,
//                 label: "Experience",
//                 icon: Icons.date_range,
//                 keyboardType: TextInputType.datetime,
//               ),
//               SizedBox(height: 16),
//               _buildTextField(
//                 controller: educationController,
//                 label: "Education",
//                 icon: Icons.phone_outlined,
//                 keyboardType: TextInputType.text,
//               ),
//               SizedBox(height: 16),
//               _buildTextField(
//                 controller: job_roleController,
//                 label: "Job Role",
//                 icon: Icons.rotate_left,
//               ),
//
//               SizedBox(height: 30),
//               // ID Proof
//               _buildImagePicker(
//                 title: "ID Proof",
//                 onImagePick: _pickIdProofImage,
//                 selectedImage: _idProofImage,
//               ),
//               SizedBox(height: 40),
//               // Register Button
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _registerUser,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue[700],
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? CircularProgressIndicator(color: Colors.white)
//                     : Text(
//                   "Register",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Helper method: Build text fields
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     bool obscureText = false,
//     Widget? suffixIcon,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.white,
//         labelText: label,
//         prefixIcon: Icon(icon, color: Colors.blue[700]),
//         suffixIcon: suffixIcon,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding: EdgeInsets.symmetric(vertical: 16),
//       ),
//     );
//   }
//
//   // Helper method: Build section titles
//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         color: Colors.grey[800],
//       ),
//     );
//   }
//
//   // Helper method: Build circular profile image picker
//   Widget _buildCircularImagePicker({
//     required String title,
//     required Function() onImagePick,
//     required XFile? selectedImage,
//   }) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: onImagePick,
//           child: CircleAvatar(
//             radius: 60,
//             backgroundColor: Colors.blue[100],
//             backgroundImage: selectedImage != null
//                 ? FileImage(File(selectedImage.path))
//                 : null,
//             child: selectedImage == null
//                 ? Icon(
//               Icons.add_a_photo_outlined,
//               size: 40,
//               color: Colors.blue[700],
//             )
//                 : null,
//           ),
//         ),
//         SizedBox(height: 12),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey[700],
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Helper method: Build rectangular image picker for ID proof
//   Widget _buildImagePicker({
//     required String title,
//     required Function() onImagePick,
//     required XFile? selectedImage,
//   }) {
//     return Column(
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey[800],
//           ),
//         ),
//         SizedBox(height: 12),
//         GestureDetector(
//           onTap: onImagePick,
//           child: Container(
//             width: 150,
//             height: 150,
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.blue[700]!, width: 2),
//             ),
//             child: selectedImage != null
//                 ? ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.file(
//                 File(selectedImage.path),
//                 fit: BoxFit.cover,
//               ),
//             )
//                 : Icon(
//               Icons.add_a_photo_outlined,
//               size: 40,
//               color: Colors.blue[700],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Method: Handle profile image pick
//   Future<void> _pickProfileImage() async {
//     final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
//     setState(() {
//       _profileImage = image;
//     });
//   }
//
//   // Method: Handle ID proof image pick
//   Future<void> _pickIdProofImage() async {
//     final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
//     setState(() {
//       _idProofImage = image;
//     });
//   }
//
//
//   // Method: Handle user registration
//   Future<void> _registerUser() async {
//     setState(() => _isLoading = true);
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       String url = prefs.getString("url") ?? '';
//
//       var request = http.MultipartRequest('POST', Uri.parse('$url/user_upload_file'));
//       request.fields.addAll({
//         'par_skills': par_skillsController.text,
//         'exp_yr': exp_yrController.text,
//         'education': educationController.text,
//         'job_role': job_roleController.text,
//
//       });
//
//
//
//       if (_idProofImage != null) {
//         request.files.add(await http.MultipartFile.fromPath('file', _idProofImage!.path));
//       }
//
//       final response = await request.send();
//       if (response.statusCode == 200) {
//         _showSnackBar(" Successful");
//         // Navigator.pushReplacement(
//         //   context,
//         //   MaterialPageRoute(builder: (context) => login()),
//         // );
//       } else {
//         _showSnackBar(" Failed");
//       }
//     } catch (e) {
//       _showSnackBar("An error occurred: $e");
//     }
//     setState(() => _isLoading = false);
//   }
//
//   // Helper method: Show snack bar
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }
// }