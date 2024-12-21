import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/common.dart';
import 'package:medicalp/cpage2.dart';
import 'package:medicalp/cpage4.dart';

class CPage1 extends StatefulWidget {
  final String username;
  final String name;

  CPage1({required this.username, required this.name});

  @override
  _CPage1State createState() => _CPage1State();
}

class _CPage1State extends State<CPage1> {
  String? name;
  bool _isLoading = true;
  Uint8List? doctorImage;

  @override
  void initState() {
    super.initState();
    _fetchName(); // Fetch user's name when the widget initializes
    _fetchDoctorImage(); // Fetch doctor's image when the widget initializes
  }

  Future<void> _fetchName() async {
    try {
      Uri apiUrl = Uri.parse(nameparsing);
      apiUrl = apiUrl.replace(queryParameters: {'user_id': widget.username});
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status']) {
          setState(() {
            name = data['data'][0]['Name'];
            _isLoading = false;
          });
        } else {
          // Handle error message if needed
        }
      } else {
        // Handle errors
      }
    } catch (e) {
      // Handle exceptions
    }
  }

  Future<void> _fetchDoctorImage() async {
    try {
      Uri apiUrl = Uri.parse(caretakerimage);
      apiUrl = apiUrl.replace(queryParameters: {'user_id': widget.username});
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            doctorImage = base64Decode(data['image']); // Decode the image
          });
        } else {
          // Handle error message if needed
        }
      } else {
        // Handle errors
      }
    } catch (e) {
      // Handle exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        backgroundColor: Colors.blue[100],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Hello,',
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
            if (!_isLoading && name != null)
              Text(
                name!, // Display the fetched name
                style: TextStyle(fontSize: 26.0),
              ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundImage: doctorImage != null
                    ? MemoryImage(doctorImage!)
                    : AssetImage('assets/Ellipse 4.png') as ImageProvider,
                radius: 40,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to CPage4 when Skip button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CPage4(
                              username: widget.username, name: name!)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    backgroundColor: Colors.blue[100],
                  ),
                  child: Text(
                    'Skip',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(), // Show loading indicator while fetching user info
      )
          : SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '   How do you feel today?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Answer by attempting the questionnaire',
                      style: TextStyle(
                        fontSize: 21,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Image.asset(
                        'assets/Ellipse23.png',
                        height: 234,
                        width: 262,
                      ),
                    ),
                    SizedBox(height: 80),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to CPage2 and pass the username and name
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CPage2(
                                    username: widget.username,
                                    name: widget.name)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 29),
                          backgroundColor: Colors.blue[100],
                        ),
                        child: Text(
                          'LET\'S START',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
