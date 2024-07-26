import 'package:flutter/material.dart';
import 'package:medicalp/a_caretakertestattempted.dart';
import 'package:medicalp/a_ctlist.dart';
import 'package:medicalp/a_dailyquestionaries.dart';


class A_dailyactivities extends StatefulWidget {
  final String? userId;
  final String? name;
  const A_dailyactivities({Key? key,this.userId, this.name}) : super(key: key);

  @override
  _A_dailyactivitiesState createState() => _A_dailyactivitiesState();
}

class _A_dailyactivitiesState extends State<A_dailyactivities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Colors.blue[100], // Set the background color of the AppBar to transparent
        elevation: 0, // Remove the elevation of the AppBar
        leading: IconButton(
          padding: EdgeInsets.only(left: 30), // Remove padding around the icon
          icon: Icon(
            Icons.arrow_back_ios,
            size: 32,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Daily Activities',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.7,
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          SizedBox(height: 40), // Add a SizedBox to create space between AppBar and body
          Container(
            alignment: Alignment.center,
            // Align the container (and its child) at the center
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => A_dailyquestionaries(
                          userId: widget.userId,
                          name: widget.name,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 17, horizontal: 60),
                    // Adjust button padding
                    backgroundColor: Colors.blue[100],
                    // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      // Adjust the circular vertices
                    ),
                  ),
                  child: Text(
                    'Daily questionnaires',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 30), // Add a gap between buttons
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TestAttempted(
                          userId: widget.userId,
                          name: widget.name,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 17, horizontal: 75),
                    // Adjust button padding
                    backgroundColor: Colors.blue[100],
                    // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      // Adjust the circular vertices
                    ),
                  ),
                  child: Text(
                    'Tests attempted',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: 20), // Add a gap between button and image
                Image.asset(
                  'assets/rafiki.png',
                  // Replace 'your_image.png' with the path to your image asset
                  width: 430, // Adjust width as needed
                  height: 383, // Adjust height as needed
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

