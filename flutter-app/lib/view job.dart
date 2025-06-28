import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const ViewReply());
}

class ViewReply extends StatelessWidget {
  const ViewReply({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'View Reply',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Accessories(title: 'View Reply'),
    );
  }
}

class Accessories extends StatefulWidget {
  const Accessories({super.key, required this.title});

  final String title;

  @override
  State<Accessories> createState() => _AccessoriesState();
}





class _AccessoriesState extends State<Accessories> {
  List<int> id_ = [];
  List<String> name_ = [];
  List<String> PETSHOP_ = [];
  List<String> type_ = [];
  List<String> category_type_ = [];
  List<String> qty_ = [];
  List<String> amount_ = [];


  // For search functionality
  List<int> filteredId = [];
  List<String> filteredName = [];
  List<String> filteredPETSHOP = [];
  List<String> filteredtype = [];
  List<String> filteredcategory_type = [];
  List<String> filteredqty = [];
  List<String> filteredamount = [];
  TextEditingController searchController = TextEditingController();

  void Accessories() async {
    List<int> id = <int>[];
    List<String> name = <String>[];
    List<String> PETSHOP = <String>[];
    List<String> type = <String>[];
    List<String> category_type = <String>[];
    List<String> qty = <String>[];
    List<String> amount = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? ''; // Ensure non-null URL
      String url = '$urls/user_view_accessories';
      var data = await http.post(Uri.parse(url), body: {});
      var jsondata = json.decode(data.body);
      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id']);
        name.add(arr[i]['name'].toString());
PETSHOP.add(arr[i]['PETSHOP']);
type.add(arr[i]['type']);
category_type.add(arr[i]['category_type']);
        qty.add(arr[i]['qty']);
        amount.add(arr[i]['amount']);
      }

      setState(() {
        id_ = id;
        name_ = name;
        PETSHOP_ = PETSHOP;
        amount_ = amount;
type_ = type;
category_type_ = category_type;
        qty_ = qty;
        // Initialize filtered lists with full data
        filteredId = id_;
        filteredName = name_;
        filteredPETSHOP = PETSHOP_;
        filteredtype = type_;
        filteredcategory_type = category_type_;
        filteredqty = qty_;
        filteredamount = amount_;
      });
    } catch (e) {
      print("Error: " + e.toString());
      Fluttertoast.showToast(msg: "Failed to load Accessories data.");
    }
  }

  void filterAccessoriess(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredId = id_;
        filteredName = name_;
        filteredPETSHOP = PETSHOP_;
        filteredtype = type_;
        filteredcategory_type = category_type_;
        filteredqty = qty_;
        filteredamount = amount_;
      });
    } else {
      setState(() {
        filteredId = [];
        filteredName = [];
        filteredPETSHOP = [];
        filteredtype = [];
        filteredcategory_type = [];
        filteredqty = [];
        filteredamount = [];
        for (int i = 0; i < name_.length; i++) {
          if (name_[i].toLowerCase().contains(query.toLowerCase())) {
            filteredId.add(id_[i]);
            filteredName.add(name_[i]);
            filteredPETSHOP.add(PETSHOP_[i]);
            filteredtype.add(type_[i]);
            filteredcategory_type.add(category_type_[i]);
            filteredqty.add(qty_[i]);
            filteredamount.add(amount_[i]);
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Accessories();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('View Accessoriess'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search Accessories by Name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  filterAccessoriess(value);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredId.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: " + filteredName[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "PetShop: " + filteredPETSHOP[index],
                                style: TextStyle(),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Type: " + filteredtype[index],
                                style: TextStyle(),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Category Type: " + filteredcategory_type[index],
                                style: TextStyle(fontSize: 14),
                              ),    Text(
                                "Amount: " + filteredamount[index],
                                style: TextStyle(fontSize: 14),
                              ),   Text(
                                "Available Quantity: " + filteredqty[index],
                                style: TextStyle(fontSize: 14),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // ElevatedButton(
                                  //   onPressed: () async {
                                  //     // Check if id_ is valid and not empty
                                  //     if (id_ != null && id_.isNotEmpty && index < id_.length) {
                                  //       // Store the selected id in SharedPreferences
                                  //       SharedPreferences sh = await SharedPreferences.getInstance();
                                  //       sh.setString('hid', id_[index].toString());
                                  //
                                  //       // Navigate to the User_Feedback screen
                                  //       Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //           builder: (context) => UserFeedback(title: 'Your Title'),
                                  //         ),
                                  //       );
                                  //     } else {
                                  //       // Handle error: id_ is null, empty or invalid index
                                  //       print("Error: Invalid id_ list or index");
                                  //       Fluttertoast.showToast(msg: "Error: Invalid Accessories data.");
                                  //     }
                                  //   },
                                  //   style: ElevatedButton.styleFrom(
                                  //     backgroundColor: Colors.pink,
                                  //   ),
                                  //   child: Text('Rating', style: TextStyle(color: Colors.white)),
                                  // ),




                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
