

import 'dart:convert';

import 'package:airesume/register.dart';
import 'package:airesume/resume%20home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart';
import 'ipset.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => IpSet()),
        );
        return false; // Prevents default back action
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Gradient Background with Image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/back.jpg'), // Replace with your background image
                  fit: BoxFit.cover, // Adjusts how the image fits the container
                ),
                gradient: LinearGradient(
                  colors: [Color(0xFFB3E5FC), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Icon


                      // App Title
                      Text(
                        "Ai Resume",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              blurRadius: 3.0,
                              color: Colors.black26,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),

                      // Subtitle
                      Text(
                        "Login to continue",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 30),

                      // Username Input
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: Offset(2, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Username",
                              hintText: "Enter your username",
                              prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Password Input
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: Offset(2, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Password",
                              hintText: "Enter your password",
                              prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Registration Button (commented out)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RegMain()),
                                );
                              },
                              child: Text("Register"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blueAccent,
                                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(color: Colors.blueAccent),
                                ),
                                elevation: 3,
                              ),
                            ),
                          ),

                          // Login Button
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                final sh = await SharedPreferences.getInstance();
                                String username = usernameController.text.trim();
                                String password = passwordController.text.trim();
                                String url = sh.getString("url").toString();
                                print(url);
                                print('====================');

                                print("Logging in...");
                                var response = await http.post(
                                  Uri.parse(url + "flutter_login"),
                                  body: {'username': username, 'psw': password},
                                );
                                print('rrrrrrr');

                                var jsonData = json.decode(response.body);
                                String status = jsonData['status'].toString();
                                String type = jsonData['type'].toString();
                                print(status + "===" + type);

                                if (status == "ok") {
                                  String lid = jsonData['lid'].toString();
                                  sh.setString("lid", lid);

                                  if (type == 'user') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JobFinderHomePage()));
                                            // builder: (context) => HomePage()));
                                  } else {
                                    print("Login error: Invalid type");
                                  }
                                } else {
                                  print("Login error: Incorrect credentials");
                                }
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                padding:
                                EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
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
          ],
        ),
      ),
    );
  }
}