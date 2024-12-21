import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/c_editprofile.dart';
import 'package:medicalp/common.dart';

class C_profile extends StatefulWidget {
  final String name;
  final String username;

  C_profile({required this.username, required this.name});

  @override
  _C_profileState createState() => _C_profileState();
}

class _C_profileState extends State<C_profile> {
  Map<String, dynamic> caretakerData = {};
  String? caretakerImagePath;

  @override
  void initState() {
    super.initState();
    fetchCaretakerDetails();
  }

  Future<void> fetchCaretakerDetails() async {
    print('Fetching caretaker details...');
    try {
      final apiUrl = Uri.parse(caretakerprofile); // Replace with your PHP URL
      final response = await http.get(apiUrl, headers: {
        'Content-Type': 'application/json',
      });
      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          setState(() {
            final caretakerDetails = responseData['data'].firstWhere(
                  (caretaker) => caretaker['user_id'] == widget.username,
              orElse: () => {},
            );
            if (caretakerDetails.isNotEmpty) {
              caretakerData = caretakerDetails;
              print('Fetched caretaker details: $caretakerData');
              caretakerImagePath = caretakerData['Caretaker_image'];
            }
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
          'Profile',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 1.50),
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
                SizedBox(height: 70),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildRow('User ID:', caretakerData['user_id'] ?? 'N/A'),
                    buildRow('Name:', caretakerData['Name'] ?? 'N/A'),
                    buildRow('Phone No:', caretakerData['phone_no'] ?? 'N/A'),
                    buildRow('Relationship:', caretakerData['Relationship'] ?? 'N/A'),
                    buildRow('Patient Name:', caretakerData['p_Name'] ?? 'N/A'),
                    buildRow('Diagnosis:', caretakerData['Diagnosis'] ?? 'N/A'),
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
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => C_editprofile(
                        username: widget.username,
                        name: caretakerData['Name'] ?? 'N/A',
                        phoneNumber: caretakerData['phone_no'] ?? 'N/A',
                        relationship: caretakerData['Relationship'] ?? 'N/A',
                        patientName: caretakerData['p_Name'] ?? 'N/A',
                        diagnosis: caretakerData['Diagnosis'] ?? 'N/A',
                        caretakerImage: caretakerImagePath,
                      ),
                    ),
                  );

                  // If result is not null, update the caretaker data
                  if (result != null) {
                    setState(() {
                      caretakerData = result;
                      caretakerImagePath = result['caretakerImage'];
                    });
                  }
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
