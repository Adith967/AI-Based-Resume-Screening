


import 'package:airesume/profile.dart';
import 'package:airesume/resume%20home.dart';
import 'package:airesume/resume%20upload.dart';
import 'package:airesume/view%20job%20more.dart';
import 'package:airesume/view%20schedule.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'd.dart';
import 'login.dart';

// Mock login page (replace with your actual Login widget)


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const JobFinderHomePage(),
    );
  }
}

class JobFinderHomePage extends StatefulWidget {
  const JobFinderHomePage({super.key});

  @override
  State<JobFinderHomePage> createState() => _JobFinderHomePageState();
}

class _JobFinderHomePageState extends State<JobFinderHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const JobFinderHomeContent(),
    const ViewSchedules(title: '',),
    const Login(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: _selectedIndex != 2
          ? BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      )
          : null,
    );
  }
}

class JobFinderHomeContent extends StatefulWidget {
  const JobFinderHomeContent({super.key});

  @override
  State<JobFinderHomeContent> createState() => _JobFinderHomeContentState();
}

class _JobFinderHomeContentState extends State<JobFinderHomeContent> {
  final TextEditingController _searchController = TextEditingController();
  List<JobListing> _jobListings = [];
  List<String> _jobTypes = ['All'];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      setState(() {
        _isLoading = true;
      });

      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? '';
      String url = '$urls/view_jobs';

      var response = await http.post(Uri.parse(url), body: {});
      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        List<JobListing> fetchedJobs = [];
        Set<String> uniqueJobTypes = {'All'};

        for (var order in jsonData['data']) {
          List<String> tags = [];
          if (order['jobtype'] != null && order['jobtype'].toString().isNotEmpty) {
            tags.add(order['jobtype'].toString());
            uniqueJobTypes.add(order['jobtype'].toString());
          }
          if (order['required_skills'] != null && order['required_skills'].toString().isNotEmpty) {
            tags.add(order['required_skills'].toString());
          }

          fetchedJobs.add(JobListing(
            id: order['id']?.toString() ?? 'Untitled id',
            title: order['job_title']?.toString() ?? 'Untitled Job',
            company: order['HR_ID']?.toString() ?? 'Unknown Company',
            location: order['job_location']?.toString() ?? 'Unknown Location',
            salary: order['req_experience']?.toString() ?? 'Not specified',
            type: order['jobtype']?.toString() ?? 'Not specified',
            posted: 'Posted recently',
            logo: Icons.work,
            tags: tags,
          ));
        }

        setState(() {
          _jobListings = fetchedJobs;
          _jobTypes = uniqueJobTypes.toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: "Failed to load jobs.");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: "An error occurred while fetching jobs: $e");
    }
  }

  void _searchJobs(String query) {
    setState(() {
      _isLoading = true;
      _searchQuery = query;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _jobListings = _jobListings.where((job) {
          final matchesSearch =
              job.title.toLowerCase().contains(query.toLowerCase()) ||
                  job.company.toLowerCase().contains(query.toLowerCase());
          final matchesFilter = _selectedFilter == 'All' ||
              job.tags.contains(_selectedFilter);
          return matchesSearch && matchesFilter;
        }).toList();
        _isLoading = false;
      });
    });
  }

  void _filterJobs(String filter) {
    setState(() {
      _selectedFilter = filter;
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      _searchJobs(_searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context) => JobFinderHomeContent(),));
        return false;
      },
      child: Scaffold(
        backgroundColor: colorScheme.tertiary,
        appBar: AppBar(
          title: const Text('Ai Resume'),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // Add your home navigation logic here
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
Navigator.push(context, MaterialPageRoute(builder: (context) => userProfile_new1(title: ''),))  ;          },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _searchJobs,
                decoration: InputDecoration(
                  hintText: 'Search for jobs or HR name...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _searchJobs('');
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _jobTypes.length,
                itemBuilder: (context, index) {
                  final jobType = _jobTypes[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(
                      jobType,
                      _getIconForJobType(jobType),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_jobListings.length} Jobs Found',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      // Implement sorting logic here
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Recent',
                        child: Text('Sort by: Recent'),
                      ),
                      const PopupMenuItem(
                        value: 'Salary',
                        child: Text('Sort by: Salary'),
                      ),
                      const PopupMenuItem(
                        value: 'Relevance',
                        child: Text('Sort by: Relevance'),
                      ),
                    ],
                    child: Text(
                      'Sort by: Recent',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _jobListings.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.work_outline,
                      size: 64,
                      color: colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No jobs found',
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try adjusting your search or filters',
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: _jobListings.length,
                itemBuilder: (context, index) {
                  return _buildJobCard(_jobListings[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final isSelected = _selectedFilter == label;
    final colorScheme = Theme.of(context).colorScheme;

    return FilterChip(
      label: Text(label),
      avatar: Icon(icon, size: 18),
      selected: isSelected,
      onSelected: (bool value) {
        _filterJobs(value ? label : 'All');
      },
      backgroundColor: Colors.white,
      selectedColor: colorScheme.primary.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : Colors.grey.shade300,
        ),
      ),
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? colorScheme.primary : Colors.black,
      ),
    );
  }

  Widget _buildJobCard(JobListing job) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to job details
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(job.logo, color: colorScheme.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          job.company,
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildJobDetailChip(job.location, Icons.location_on),
                  _buildJobDetailChip(job.type, Icons.access_time),
                  _buildJobDetailChip(job.salary, Icons.attach_money),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    job.posted,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  ElevatedButton(

          onPressed: () async{
            final sh = await SharedPreferences.getInstance();
            sh.setString('jid', job.id.toString());

            Navigator.push(context, MaterialPageRoute(builder: (context) => ViewJobsMore(title: '',),));

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                    ),
                    child: const Text('More'),
                  ), ElevatedButton(

          onPressed: () async{
            final sh = await SharedPreferences.getInstance();
            sh.setString('jid', job.id.toString());

            Navigator.push(context, MaterialPageRoute(builder: (context) => Resumes(),));

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                    ),
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobDetailChip(String text, IconData icon) {
    return Chip(
      label: Text(text),
      avatar: Icon(icon, size: 16),
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      labelStyle: const TextStyle(fontSize: 12),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  IconData _getIconForJobType(String jobType) {
    switch (jobType.toLowerCase()) {
      case 'all':
        return Icons.all_inclusive;
      case 'remote':
        return Icons.work_outline;
      case 'full-time':
        return Icons.access_time;
      case 'tech':
        return Icons.code;
      case 'design':
        return Icons.design_services;
      default:
        return Icons.work;
    }
  }
}

class JobListing {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String type;
  final String posted;
  final IconData logo;
  final List<String> tags;

  JobListing({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.type,
    required this.posted,
    required this.logo,
    required this.tags,
  });
}