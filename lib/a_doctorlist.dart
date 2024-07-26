import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/common.dart';
import 'dart:typed_data';

class Doctorslist extends StatefulWidget {
  const Doctorslist({Key? key}) : super(key: key);

  @override
  _DoctorslistState createState() => _DoctorslistState();
}

class _DoctorslistState extends State<Doctorslist> {
  late List<dynamic> doctorList = [];
  late List<dynamic> filteredDoctors = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    print('Fetching doctors...');
    try {
      final response = await http.get(Uri.parse(doctorslist));
      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          setState(() {
            doctorList = responseData['data'];
            filteredDoctors = doctorList;
            print('Fetched ${doctorList.length} doctors.');
          });
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Failed to load doctors. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching doctors: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _onSearchChanged() {
    setState(() {
      filteredDoctors = doctorList.where((doctor) =>
      doctor['user_id']!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          doctor['Name']!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          doctor['Age']!.toString().toLowerCase().contains(_searchController.text.toLowerCase())).toList();
      print(filteredDoctors);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.only(left: 20),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 80,
        backgroundColor: Colors.blue[100],
        title: Text(
          'Doctor List',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 45,
              child: TextField(
                controller: _searchController,
                onChanged: (_) => _onSearchChanged(),
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
            child: ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorPage(
                          userId: filteredDoctors[index]['user_id'],
                          name: filteredDoctors[index]['Name'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                              image: filteredDoctors[index]['doctorimage'] != null
                                  ? MemoryImage(base64Decode(filteredDoctors[index]['doctorimage']))
                                  : AssetImage('assets/placeholder_image.png') as ImageProvider<Object>,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User ID: ${filteredDoctors[index]['user_id']}',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Name: ${filteredDoctors[index]['Name']}',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Age: ${filteredDoctors[index]['Age']}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class DoctorPage extends StatefulWidget {
  final String? userId;
  final String? name;

  const DoctorPage({Key? key, this.userId, this.name}) : super(key: key);

  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  Map<String, dynamic> doctorData = {};

  @override
  void initState() {
    super.initState();
    fetchDoctorDetails();
  }

  Future<void> fetchDoctorDetails() async {
    print('Fetching doctor details...');
    try {
      final Uri uri = Uri.parse(doctordetails);
      final response = await http.post(uri, body: {
        'user_id': widget.userId ?? '',
        'Name': widget.name ?? '',
      });
      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          setState(() {
            doctorData = responseData['data'];
            print('Fetched doctor details: $doctorData');
          });
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Failed to load doctor details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching doctor details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.only(left: 20),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 80,
        backgroundColor: Colors.blue[100],
        title: Text(
          'Doctor Details',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: doctorData.containsKey('doctorimage') && doctorData['doctorimage'] is String
                          ? DecorationImage(
                        image: MemoryImage(base64Decode(doctorData['doctorimage'])),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildRow('Name:', doctorData['Name'] ?? ''),
                    buildRow('Password:', doctorData['password'] ?? ''),
                    buildRow('Email ID:', doctorData['email_id'] ?? ''),
                    buildRow('Age:', doctorData['Age']?.toString() ?? ''),
                    buildRow('Gender:', doctorData['Gender'] ?? ''),
                    buildRow('Phone No:', doctorData['phone_no'] ?? ''),
                    buildRow('Designation:', doctorData['designation'] ?? ''),
                    buildRow('Institution:', doctorData['institution'] ?? ''),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[100],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  // Implement editing functionality
                },
                child: Text(
                  'Edit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120, // Adjust the width based on your preference
            child: Text(
              '$label',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10),
          Text(
            ':',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(width: 35),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
