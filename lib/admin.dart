import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:medicalp/apage1.dart';
import 'common.dart';

class AdminPage extends StatelessWidget {
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    // Define the URL of your PHP backend
    var url = Uri.parse(adminlogin);

    // Create a Map object containing the login credentials
    var data = {
      'user_id': userIdController.text,
      'password': passwordController.text,
    };

    // Send an HTTP POST request to the backend
    var response = await http.post(url, body: data);

    // Parse the JSON response
    var responseData = jsonDecode(response.body);

    print("aaaaa: ${responseData.toString()}");

    // Check if login was successful
    if (responseData['status']) {
      // Navigate to the next screen if login was successful
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Apage1()),
      );
    } else {
      // Display an error message if login failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseData['message']),
        ),
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
                            'assets/adminlog.jpg',
                            height: 150,
                            width: 190,
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: userIdController,
                            decoration: InputDecoration(
                              hintText: "user id",
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(height: 10),
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
                            onPressed: () => login(context),
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
