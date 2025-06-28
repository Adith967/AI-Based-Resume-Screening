import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class IpSet extends StatefulWidget {
  const IpSet({super.key});

  @override
  State<IpSet> createState() => _IpSetState();
}

class _IpSetState extends State<IpSet> {
  final TextEditingController ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Title
                Text(
                  "Ai Resume",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 10),

                // Subtitle
                Text(
                  "Enter IP to continue",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 30),

                // Input Field Container
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  child: TextField(
                    controller: ipController,
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "IP Address",
                      labelStyle: TextStyle(color: Colors.black54),
                      hintText: "Enter a valid IP address",
                      hintStyle: TextStyle(color: Colors.black38),
                      prefixIcon: Icon(Icons.wifi, color: Colors.blueAccent),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Proceed Button
                ElevatedButton(
                  onPressed: () async {
                    String ip = ipController.text.trim();
                    print(ip);
                    print('ippppppp');
                    if (ip.isNotEmpty) {
                      final sh = await SharedPreferences.getInstance();
                      sh.setString("url", "http://$ip:8000/");
                      sh.setString("imgurl", "http://$ip:8000");

                      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter a valid IP address.")),
                      );
                    }
                  },
                  child: Text(
                    "Proceed",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
