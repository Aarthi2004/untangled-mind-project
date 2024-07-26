import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/cpage1.dart';
import 'common.dart';
import 'package:shared_preferences/shared_preferences.dart';

 // Import your Dart file here

class Caretaker extends StatefulWidget {
  const Caretaker({Key? key}) : super(key: key);

  @override
  _CaretakerState createState() => _CaretakerState();
}

class _CaretakerState extends State<Caretaker> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Future<void> login() async {
    String username = usernameController.text;
    String password = passwordController.text;
    String name=nameController.text;

    // Send login data to PHP script
    var url = Uri.parse(caretakerlogin); // Using the variable from your Dart file
    var response = await http.post(
      url,
      body: jsonEncode({'user_id': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    // Handle response
    var data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      // Store username in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', username);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CPage1(username:usernameController.text,name:nameController.text)),
      );
    } else {
      // Handle login failure
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Invalid username or password'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardWidth = screenWidth * 0.8;
    double cardHeight = screenHeight * 0.52;
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bluebackground.jpg'), // Replace 'background_image.jpg' with your image file
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black,
                    color: Colors.white70,
                    child: Container(
                      width: cardWidth,
                      height: cardHeight,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: AssetImage('assets/whitebackground.png'), // Replace 'whitebackground.jpg' with your image file
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/caretakerimage.jpg',
                            height: 150,
                            width: 190,
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              hintText: "user id",
                              prefixIcon:Icon(Icons.person),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "password",
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: login,
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[100],
                              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
