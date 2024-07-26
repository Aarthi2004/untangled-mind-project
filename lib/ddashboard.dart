import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/a_ctlist.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:medicalp/common.dart';

class ddashboard extends StatefulWidget {
  final String userid;

  ddashboard({required this.userid});

  @override
  _ddashboardState createState() => _ddashboardState();
}

class _ddashboardState extends State<ddashboard> {
  String doctorName = '';
  Uint8List? doctorImage;
  late List<dynamic> filteredCaretakers = [];
  List<dynamic> caregiverList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDoctorName();
    fetchDoctorImage(); // Fetch the doctor's image
    fetchCaregivers();
    _searchController.addListener(_onSearchChanged); // Add listener
  }

  Future<void> fetchDoctorName() async {
    Uri apiUrl = Uri.parse(Doctorname); // Adjust your URL
    apiUrl = apiUrl.replace(queryParameters: {'user_id': widget.userid});
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true && data['data'].length > 0) {
        setState(() {
          doctorName = data['data'][0]['Name'];
        });
      } else {
        print('Error: ${data['message']}');
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
    }
  }

  Future<void> fetchDoctorImage() async {
    Uri apiUrl = Uri.parse(docimage);
    apiUrl = apiUrl.replace(queryParameters: {'user_id': widget.userid});
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          doctorImage = base64Decode(data['image']); // Decode the image
        });
      } else {
        print('Error: ${data['message']}');
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
    }
  }

  Future<void> fetchCaregivers() async {
    final response = await http.get(Uri.parse(Caretakerlist)); // Adjust your URL
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true && data['data'] != null) {
        setState(() {
          caregiverList = data['data'];
          filteredCaretakers = caregiverList; // Initialize filteredCaretakers
        });
      } else {
        print('Error: ${data['message']}');
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
    }
  }

  void _onSearchChanged() {
    setState(() {
      filteredCaretakers = caregiverList.where((caretaker) =>
      caretaker['user_id']
          .toString()
          .toLowerCase()
          .contains(_searchController.text.toLowerCase()) ||
          caretaker['Name']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 110,
        backgroundColor: Colors.blue[100],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Hello,',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'Dr. $doctorName',
              style: TextStyle(fontSize: 26.0),
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: doctorImage != null
                    ? MemoryImage(doctorImage!)
                    : AssetImage('assets/doctor.png') as ImageProvider,
                radius: 30,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 45,
              child: TextField(
                controller: _searchController,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: filteredCaretakers.map((caregiver) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Caretakerpage(
                              userId: caregiver['user_id'],
                              name: caregiver['Name'],
                              caretaker: null,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                image: DecorationImage(
                                  image: caregiver['Caretaker_image'] != null
                                      ? MemoryImage(base64Decode(caregiver['Caretaker_image']))
                                      : AssetImage('assets/placeholder_image.png') as ImageProvider<Object>,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'User ID: ${caregiver['user_id']}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'Name: ${caregiver['Name']}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'Diagnosis: ${caregiver['Diagnosis']}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
