
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
      home: const ViewJobsMore(title: 'View Reply'),
    );
  }
}

class ViewJobsMore extends StatefulWidget {
  const ViewJobsMore({super.key, required this.title});

  final String title;

  @override
  State<ViewJobsMore> createState() => _ViewJobsMoreState();
}

class _ViewJobsMoreState extends State<ViewJobsMore> {
  List<Map<String, String>> orders = [];
  List<Map<String, String>> filteredOrders = [];
  TextEditingController searchController = TextEditingController();

  // Fetch orders from the backend
  Future<void> fetchOrders() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? '';
      String lid = sh.getString('jid') ?? '';
      String url = '$urls/view_jobs_more';

      var response = await http.post(Uri.parse(url), body: {
        'jid': lid,
      });

      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        List<Map<String, String>> fetchedOrders = [];
        for (var order in jsonData['data']) {
          fetchedOrders.add({
            'id': order['id'],
            'HR_ID': order['HR_ID'],
            'job_title': order['job_title'],
            'job_desc': order['job_desc'],
            'required_skills': order['required_skills'],
            'req_experience': order['req_experience'],
            'req_education': order['req_education'],
            'job_location': order['job_location'],
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
            order['PETSHOP']!.toLowerCase().contains(query.toLowerCase()))
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

                            const SizedBox(height: 8),
                            Text("Hr Name: ${order['HR_ID']}"),
                            const SizedBox(height: 8),
                            Text("Job Title: ${order['job_title']}"),
                            const SizedBox(height: 8),
                            Text("Description: ${order['job_desc']}"),
                            const SizedBox(height: 8),
                            Text("Required Skills: ${order['required_skills']}"),
                            const SizedBox(height: 8),
                            Text("Experience: ${order['req_experience']}"),

                            const SizedBox(height: 8),
                            Text("Education: ${order['req_education']}"),
                            const SizedBox(height: 8),
                            Text("Location: ${order['job_location']}"),

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
