import 'package:flutter/material.dart';
import 'package:medicalp/c_topic.dart';

class testsuccessful extends StatelessWidget {
  final String username;
  final String name;

  testsuccessful({required this.username,required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      body: Stack(
        children: [
          // Centered Image
          Center(
            child: Container(
              padding: EdgeInsets.only(bottom: 150), // Adjust padding as needed
              child: Image.asset(
                'assets/Ellipse 22.png', // Replace 'assets/Ellipse 22.png' with your image path
                //fit: BoxFit.cover,
                width: 271, // Adjust the width of the image
                height: 232, // Adjust the height of the image
              ),
            ),
          ),
          // Centered Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hurray!!",
                  style: TextStyle(
                    fontSize: 29,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 80), // Adjust spacing between text and image
                Padding(
                  padding: EdgeInsets.only(bottom: 280.0), // Modify padding as needed
                  child: Text(
                    "     You have answered all \n the questions successfully",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Text "That's really good"
          Positioned(
            bottom: 320,
            left: 20,
            right: 20,
            child: Center(
              child: Text(
                "That's really good :)",
                style: TextStyle(
                  fontSize: 29,
                  letterSpacing: 1.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // ElevatedButton
          Positioned(
            bottom: 150,
            left: 20,
            right: 20,
            child: Center(
              child: ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Background color
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 70),
                ),
                child: Text(
                  "Continue Watching",
                  style: TextStyle(fontSize: 27,color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
