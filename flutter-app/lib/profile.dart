import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const userProfile_new1(title: 'User Profile'),
    );
  }
}

class userProfile_new1 extends StatefulWidget {
  const userProfile_new1({super.key, required this.title});

  final String title;

  @override
  State<userProfile_new1> createState() => _userProfile_new1State();
}

class _userProfile_new1State extends State<userProfile_new1> {
  String name = 'name';
  String email = 'email';
  String contact = 'phone';
  String skill = 'skill';
  String education = 'education';
  String exp = 'exp';

  @override
  void initState() {
    super.initState();
    senddata();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  JobFinderHomePage()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue, // Green color for the AppBar
          title: Text('Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  userProfile_new1(title: '',)),
              );
            },
          ),
        ),
        backgroundColor: Colors.grey.shade300,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Theme.of(context).textTheme.headline6,
                            ),

                          ],
                        ),
                        // Spacer(),
                        // CircleAvatar(
                        //   backgroundColor: Colors.blueAccent,
                        //   child: IconButton(
                        //     onPressed: () {
                        //       Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(),));
                        //       // Navigate to Edit Profile page
                        //     },
                        //     icon: const Icon(
                        //       Icons.edit_outlined,
                        //       color: Colors.white,
                        //       size: 18,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text("Profile Information"),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Skill'),
                        subtitle: Text(skill),
                        leading: const Icon(Icons.location_city),
                      ),
                      ListTile(
                        title: const Text('Email'),
                        subtitle: Text(email),
                        leading: const Icon(Icons.mail_outline),
                      ),
                      ListTile(
                        title: const Text("Phone"),
                        subtitle: Text(contact),
                        leading: const Icon(Icons.phone),
                      ),

                      ListTile(
                        title: const Text("Education"),
                        subtitle: Text(education),
                        leading: const Icon(Icons.history_edu),
                      ), ListTile(
                        title: const Text("Experience"),
                        subtitle: Text(exp),
                        leading: const Icon(Icons.expand_more),
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

  void senddata() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    final urls = Uri.parse(url + "user_view_profile");

    try {
      final response = await http.post(urls, body: {
        'lid': lid,
      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          setState(() {
            email = jsonDecode(response.body)['email'].toString();
            name = jsonDecode(response.body)['full_name'].toString();
            contact = jsonDecode(response.body)['contact_no'].toString();
            skill = jsonDecode(response.body)['skill'].toString();
            education = jsonDecode(response.body)['education'].toString();
            exp = jsonDecode(response.body)['exp'].toString();
          });
        } else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
