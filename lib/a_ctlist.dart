import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/a_dailyactivities.dart';
import 'package:medicalp/caretaker.dart';
import 'common.dart';

class ctlist extends StatefulWidget {
  const ctlist({Key? key}) : super(key: key);

  @override
  _ctlistState createState() => _ctlistState();
}

class _ctlistState extends State<ctlist> {
  late List<dynamic> CaretakerList = [];
  late List<dynamic> filteredCaretakers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCaretakers();
  }

  Future<void> fetchCaretakers() async {
    print('Fetching Caretakers...');
    try {
      final response = await http.get(Uri.parse(Caretakerlist));
      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          setState(() {
            CaretakerList = responseData['data'];
            filteredCaretakers = CaretakerList;
            print('Fetched ${CaretakerList.length} Caretakers.');
          });
        } else {
          throw Exception(responseData['message']);
        }

      } else {
        throw Exception('Failed to load caretakers. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Caretakers: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _onSearchChanged() {
    setState(() {
      filteredCaretakers = CaretakerList.where((caretaker) =>
      caretaker['user_id'].toString().toLowerCase().contains(_searchController.text.toLowerCase()) ||
          caretaker['Name'].toString().toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
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
          'Caretaker List',
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
                controller: _searchController, // Assign controller to search field
                onChanged: (_) => _onSearchChanged(), // Call _onSearchChanged when text changes
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
              itemCount: filteredCaretakers.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Caretakerpage(
                          userId: filteredCaretakers[index]['user_id'],
                          name: filteredCaretakers[index]['Name'], caretaker: null,),

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
                              image: filteredCaretakers[index]['Caretaker_image'] != null
                                  ? MemoryImage(base64Decode(filteredCaretakers[index]['Caretaker_image']))
                                  : AssetImage('assets/placeholder_image.png') as ImageProvider<Object>, // Placeholder image
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User ID: ${filteredCaretakers[index]['user_id']}',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Name: ${filteredCaretakers[index]['Name']}',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Age: ${filteredCaretakers[index]['Age']}',
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

class Caretakerpage extends StatefulWidget {
  final String? userId;
  final String? name;

  const Caretakerpage({Key? key, this.userId, this.name, required caretaker}) : super(key: key);

  @override
  _CaretakerPageState createState() => _CaretakerPageState();
}

class _CaretakerPageState extends State<Caretakerpage> {
  Map<String, dynamic> caretakerData = {}; // Changed from doctorData

  @override
  void initState() {
    super.initState();
    fetchCaretakerDetails();
  }

  Future<void> fetchCaretakerDetails() async {
    print('Fetching caretaker details...');
    try {
      final Uri uri = Uri.parse(Caretakerdetails);
      final response = await http.post(uri, body: {
        'user_id': widget.userId ?? '',
        'Name': widget.name ?? '',
      });
      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          setState(() {
            caretakerData = responseData['data'];
            print('Fetched caretaker details: $caretakerData');
          });
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Failed to load caretaker details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching caretaker details: $e');
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
        'Caretaker Details',
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
                    image: caretakerData.containsKey('Caretaker_image') && caretakerData['Caretaker_image'] is String
                        ? DecorationImage(
                      image: MemoryImage(base64Decode(caretakerData['Caretaker_image'])),
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
                  buildRow('user id', caretakerData['user_id'] ?? ''),
                  buildRow('Name:', caretakerData['Name'] ?? ''),
                  buildRow('Password:', caretakerData['password'] ?? ''),
                  buildRow('Age:', caretakerData['Age'] ?? ''),
                  buildRow('Gender:', caretakerData['Gender'] ?? ''),
                  buildRow('Phone No:', caretakerData['phone_no'] ?? ''),
                  buildRow('Relationship:', caretakerData['Relationship'] ?? ''),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 240.0), // Adjust right padding to move text to the left
                      child: Text(
                        'Patient Details',
                        style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  buildRow('Name:', caretakerData['p_Name'] ?? ''),
                  buildRow('Age:', caretakerData['p_Age'] ?? ''),
                  buildRow('Gender:', caretakerData['p_Gender'] ?? ''),
                  buildRow('Diagnosis:', caretakerData['Diagnosis'] ?? ''),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => A_dailyactivities(
                      userId: widget.userId,
                      name: widget.name,
                    ),
                  ),
                );
              },
              child: Text(
                'View Activity',
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

  Widget buildRow(String label, dynamic value,) {
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
                  value != null ? value.toString() : 'N/A',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
            ),
        );
  }
}
