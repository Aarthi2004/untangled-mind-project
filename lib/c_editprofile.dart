import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/common.dart';

class C_editprofile extends StatefulWidget {
  final String username;
  final String name;
  final String phoneNumber;
  final String relationship;
  final String patientName;
  final String diagnosis;
  final String? caretakerImage;

  C_editprofile({
    required this.username,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    required this.patientName,
    required this.diagnosis,
    required this.caretakerImage,
  });

  @override
  State<C_editprofile> createState() => _C_editprofileState();
}

class _C_editprofileState extends State<C_editprofile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController relationshipController = TextEditingController();
  TextEditingController patientNameController = TextEditingController();
  TextEditingController diagnosisController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with provided data
    nameController.text = widget.name;
    phoneNumberController.text = widget.phoneNumber;
    relationshipController.text = widget.relationship;
    patientNameController.text = widget.patientName;
    diagnosisController.text = widget.diagnosis;
  }

  Future<void> _saveProfile() async {
    // Prepare the data to send
    Map<String, String> data = {
      'user_id': widget.username,
      'Name': nameController.text,
      'phone_no': phoneNumberController.text,
      'p_Name': patientNameController.text,
      'Relationship': relationshipController.text,
      'Diagnosis': diagnosisController.text,
    };

    // Send a POST request to your PHP endpoint
    Uri url = Uri.parse(editcaretakerprofile);
    final response = await http.post(
      url,
      body: data,
    );

    // Check the response status
    if (response.statusCode == 200) {
      // Request successful, handle response
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == true) {
        // Data updated successfully
        // Navigate back to the previous page
        Navigator.of(context).pop({
          'username': widget.username,
          'name': nameController.text,
          'phoneNumber': phoneNumberController.text,
          'relationship': relationshipController.text,
          'patientName': patientNameController.text,
          'diagnosis': diagnosisController.text,
          'caretakerImage': widget.caretakerImage,
        });

      } else {
        // Error occurred, handle accordingly
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(responseData['message']),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      // Request failed, handle accordingly
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to save profile. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
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
              Container(
                width: 150,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: widget.caretakerImage != null
                      ? DecorationImage(
                    image: MemoryImage(
                      base64Decode(widget.caretakerImage!),
                    ),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
              ),
              SizedBox(height: 20),
              buildRow('User ID:', widget.username, readOnly: true),
              buildRow('Name:', nameController),
              buildRow('Phone Number:', phoneNumberController),
              buildRow('Relationship:', relationshipController),
              buildRow('Patient Name:', patientNameController),
              buildRow('Diagnosis:', diagnosisController),
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

  Widget buildRow(String label, dynamic controller, {bool readOnly = false}) {
    Widget textField;
    if (controller is TextEditingController) {
      textField = Expanded(
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding:
            EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            hintText: 'Enter $label',
          ),
        ),
      );
    } else if (controller is String) {
      textField = Expanded(
        child: Text(
          controller,
          style: TextStyle(fontSize: 16), // Adjust font size as needed
        ),
      );
    } else {
      throw ArgumentError('Invalid controller type: $controller');
    }

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
          textField,
        ],
      ),
    );
  }
}
