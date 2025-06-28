
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class ViewSchedules extends StatefulWidget {
  const ViewSchedules({super.key, required this.title});

  final String title;

  @override
  State<ViewSchedules> createState() => _ViewSchedulesState();
}

class _ViewSchedulesState extends State<ViewSchedules> {
  List<Map<String, String>> orders = [];
  List<Map<String, String>> filteredOrders = [];
  TextEditingController searchController = TextEditingController();

  // Fetch orders from the backend
  Future<void> fetchOrders() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? '';
      String lid = sh.getString('lid') ?? '';
      String url = '$urls/user_view_interview';
      print(url);
      print('============');

      var response = await http.post(Uri.parse(url), body: {
        'lid': lid,
      });

      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        List<Map<String, String>> fetchedOrders = [];
        for (var order in jsonData['data']) {
          fetchedOrders.add({
            'id': order['id'],
            'HR_ID': order['HR_ID'],
            'job_title': order['job_title'],
            'interview_date': order['interview_date'],
            'interview_time': order['interview_time'],

            'jobtype': order['jobtype'],
          });
        }

        setState(() {
          orders = fetchedOrders;
          filteredOrders = fetchedOrders;
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to load orders.");
      }
    } catch (e) {
      print("Error: $e");
      Fluttertoast.showToast(msg: "An error occurred while fetching orders.");
    }
  }

  // Filter orders based on the search query
  void filterOrders(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredOrders = orders;
      });
    } else {
      setState(() {
        filteredOrders = orders
            .where((order) =>
            order['']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
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
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (BuildContext context, int index) {
                  var order = filteredOrders[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date: ${order['interview_date']}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("Hr Name: ${order['HR_ID']}"),
                            const SizedBox(height: 8),
                            Text("Job Title: ${order['job_title']}"),
                            const SizedBox(height: 8),
                           

                            const SizedBox(height: 8),
                            Text("Job Type: ${order['jobtype']}"),
                          ],
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
