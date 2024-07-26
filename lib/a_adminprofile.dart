import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicalp/a_admineditprofile.dart';
import 'package:medicalp/common.dart';

class A_adminprofile extends StatefulWidget {
  const A_adminprofile({Key? key}) : super(key: key);
  @override
  State<A_adminprofile> createState() => _A_adminprofileState();
}

class _A_adminprofileState extends State<A_adminprofile> {
  // Define variables to hold user details
  String? userId;
  String? name;
  String? email;
  String? phone;
  String? institution;
  String? designation;

  @override
  void initState() {
    super.initState();
    // Call the function to fetch user details when the widget initializes
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    try {
      // Make a GET request to your PHP endpoint
      var response = await http.get(Uri.parse(adminprofile));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode the JSON response
        var data = json.decode(response.body);

        // Check if the response contains user details
        if (data['status']) {
          // Extract user details from the response
          var userData = data['data'][0];
          setState(() {
            userId = userData['user_id'];
            name = userData['Name'];
            email = userData['email_id'];
            phone = userData['phone_no'];
            institution = userData['institution'];
            designation = userData['designation'];
          });
        }
      } else {
        // Handle error
        print('Failed to load user details: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching user details: $e');
    }
  }

  void updateUserDetails(String newName, String newPhone, String newEmail, String newInstitution, String newDesignation) {
    setState(() {
      name = newName;
      phone = newPhone;
      email = newEmail;
      institution = newInstitution;
      designation = newDesignation;
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
          'Profile',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20), // Add space between app bar and image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 150),
            child: Image.asset(
              'assets/Ellipse123.png', // Add your image path here
              width: 80,
              height: 100,
            ),
          ),
          SizedBox(height: 70), // Add space between image and user details
          buildRow('User ID', userId ?? 'N/A'),
          buildRow('Name', name ?? 'N/A'),
          buildRow('Email', email ?? 'N/A'),
          buildRow('Phone Number', phone ?? 'N/A'),
          buildRow('Institution', institution ?? 'N/A'),
          buildRow('Designation', designation ?? 'N/A'),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[100],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => A_admineditprofile(
                      userId: userId ?? '',
                      name: name ?? '',
                      phoneNumber: phone ?? '',
                      email: email ?? '',
                      institution: institution ?? '',
                      designation: designation ?? '',
                      onSave: updateUserDetails,
                    )),
                  );
                },
                child: Text(
                  'Edit',
                  textAlign: TextAlign.start,
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
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 40),
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
