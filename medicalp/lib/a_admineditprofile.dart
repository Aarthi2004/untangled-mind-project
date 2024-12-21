import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/common.dart';

class A_admineditprofile extends StatefulWidget {
  final String name;
  final String userId;
  final String phoneNumber;
  final String email;
  final String designation;
  final String institution;
  final Function(String, String, String, String, String) onSave;

  A_admineditprofile({
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.designation,
    required this.institution,
    required this.onSave,
  });

  @override
  State<A_admineditprofile> createState() => _A_admineditprofileState();
}

class _A_admineditprofileState extends State<A_admineditprofile> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController institutionController = TextEditingController();
  TextEditingController designationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userIdController.text = widget.userId;
    nameController.text = widget.name;
    phoneNumberController.text = widget.phoneNumber;
    emailController.text = widget.email;
    institutionController.text = widget.institution;
    designationController.text = widget.designation;
  }

  Future<void> _saveProfile() async {
    final url = admineditprofile; // Replace this with your PHP endpoint
    final response = await http.post(
      Uri.parse(url),
      body: {
        'user_id': userIdController.text,
        'Name': nameController.text,
        'phone_no': phoneNumberController.text,
        'email_id': emailController.text,
        'institution': institutionController.text,
        'designation': designationController.text,
      },
    );

    final responseData = json.decode(response.body);
    if (responseData['status']) {
      // Call the onSave callback function
      widget.onSave(
        nameController.text,
        phoneNumberController.text,
        emailController.text,
        institutionController.text,
        designationController.text,
      );

      // Handle successful update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseData['message']),
        ),
      );
      // Navigate back to the previous page
      Navigator.of(context).pop();
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseData['message']),
          backgroundColor: Colors.red,
        ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Implement image selection functionality
                },
                child: Container(
                  width: 150,
                  height: 150,
                  child: Image.asset(
                    'assets/Ellipse123.png', // Add your image path here
                    width: 80,
                    height: 100,
                  ),
                ),
              ),
              SizedBox(height: 20),
              buildRow('User ID:', userIdController, enabled: false), // Make User ID field uneditable
              buildRow('Name:', nameController),
              buildRow('Phone No:', phoneNumberController),
              buildRow('Email:', emailController),
              buildRow('Institution:', institutionController),
              buildRow('Designation:', designationController),
            ],
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
                onTap: _saveProfile,
                child: Text(
                  'Save',
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

  Widget buildRow(String label, TextEditingController controller, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
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
          SizedBox(width: 15),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                hintText: 'Enter $label',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
