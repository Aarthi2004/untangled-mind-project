import 'package:flutter/material.dart';
import 'package:medicalp/cTTq5.dart';

class ttq4 extends StatefulWidget {
  final String username;
  final String name;

  ttq4({required this.username,required this.name});

  @override
  _ttq4State createState() => _ttq4State();
}

class _ttq4State extends State<ttq4> {
  int selectedOptionIndex = -1; // Track the selected option index, -1 indicates no option selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.lightBlue[100],
        title: Text(
          'TAKE TEST',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
        // Adding border to the AppBar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0), // Adjust the value as needed
          ),
          side: BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Question 4:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildOption(0, 'Option 1'),
                buildOption(1, 'Option 2'),
                buildOption(2, 'Option 3'),
                buildOption(3, 'Option 4'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue[100],
          border: Border(
            top: BorderSide(
              color: Colors.black, // Border color
              width: 1.50, // Border width
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: BottomAppBar(
          color: Colors.transparent, // Set bottom app bar color to transparent
          child: Container(
            height: 70.0,
            padding: EdgeInsets.symmetric(horizontal: 20.0), // Add padding for space around the "Next" text
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align widgets at both ends
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);// Implement functionality for "Previous" button
                  },
                  child: Text(
                    '< Previous',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
                Spacer(), // Add spacer to push "Next" button to the right end
                GestureDetector(
                  onTap: () {
                    if (selectedOptionIndex != -1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ttq5(username: widget.username, name: widget.name)),
                      );
                    } else {
                      // Show a message or any other action if no option is selected
                    }
                  },
                  child: Text(
                    'Next >',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: selectedOptionIndex != -1 ? Colors.black : Colors.grey, // Change color based on option selection
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOption(int index, String optionText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                selectedOptionIndex = index;
              });
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(340, 52),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Container(
              width: 200,
              height: 40,
              child: Center(
                child: Text(optionText),
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 8,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedOptionIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(30), // Circular clickable area
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedOptionIndex == index ? Colors.blue : Colors.grey[300], // Change color based on option selection
                ),
                // Icon indicating selection
              ),
            ),
          ),
        ],
      ),
    );
  }
}
