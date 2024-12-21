import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart'; // Import the permission handler package
import 'package:medicalp/common.dart';
import 'a_admineditprofile.dart';

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

  bool _isDownloading = false; // To show loading indicator during download

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

  Future<void> downloadCSV(BuildContext context) async {
    setState(() {
      _isDownloading = true;
    });

    try {
      final response = await http.get(Uri.parse(downloaddetails)); // Updated URL assignment
      if (response.statusCode == 200) {
        // Allow user to pick a directory
        String? directoryPath = await FilePicker.platform.getDirectoryPath();
        if (directoryPath == null) {
          Fluttertoast.showToast(
            msg: 'No Directory Selected',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
          return;
        }

        // Generate a unique filename
        String fileName = 'patient_details_${DateTime.now().millisecondsSinceEpoch}.csv';
        String filePath = '$directoryPath/$fileName';
        File file = File(filePath);

        // Ensure a unique filename by checking if the file exists
        int counter = 1;
        while (await file.exists()) {
          fileName = 'patient_details_${DateTime.now().millisecondsSinceEpoch}_$counter.csv';
          filePath = '$directoryPath/$fileName';
          file = File(filePath);
          counter++;
        }

        // Write the CSV file to the selected directory
        await file.writeAsBytes(response.bodyBytes);
        print('CSV saved at: $filePath');

        // Notify user of success
        Fluttertoast.showToast(
          msg: 'Saved Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Error Downloading CSV',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      Fluttertoast.showToast(
        msg: 'An error occurred',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
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

  void _showDownloadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Download'),
          content: Text('Do you want to download the profile data?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                downloadCSV(context); // Call the download function
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
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
            icon: Icon(Icons.download),
            onPressed: _showDownloadDialog, // Show the download confirmation dialog
          ),
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
                    MaterialPageRoute(
                      builder: (context) => A_admineditprofile(
                        userId: userId ?? '',
                        name: name ?? '',
                        phoneNumber: phone ?? '',
                        email: email ?? '',
                        institution: institution ?? '',
                        designation: designation ?? '',
                        onSave: updateUserDetails,
                      ),
                    ),
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
