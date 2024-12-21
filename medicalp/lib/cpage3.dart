import 'package:flutter/material.dart';
import 'package:medicalp/cpage4.dart';

class cpage3 extends StatelessWidget {
  final String username;
  final String name;
  cpage3({required this.username,required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: Stack(
        children: [
          // Centered Image
          Center(
            child: Container(
              padding: EdgeInsets.only(bottom: 110), // Adjust padding as needed
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
                  padding: EdgeInsets.only(bottom: 230.0), // Modify padding as needed
                  child: Text(
                    "You are done with the \n      questionnarie",
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
            bottom: 300,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CPage4(username: username, name: name)), // Replace apage2() with the page you want to navigate to
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Background color
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 70),
                ),
                child: Text(
                  "Next",
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
