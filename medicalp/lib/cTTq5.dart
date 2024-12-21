import 'package:flutter/material.dart';
import 'package:medicalp/ctestsuccessful.dart';

class ttq5 extends StatefulWidget {
  final String username;
  final String name;

  ttq5({required this.username,required this.name});

  @override
  _ttq5State createState() => _ttq5State();
}

class _ttq5State extends State<ttq5> {
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
              'Question 5:',
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
      bottomNavigationBar:Container(
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
        height: 70.0,
        padding: EdgeInsets.symmetric(horizontal: 20.0), // Add padding for space around the buttons
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align widgets at both ends
          children: [
            GestureDetector(
              onTap: () {
                // Implement functionality for "Previous" button
                Navigator.pop(context);
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
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(20), // Increase content padding
                      backgroundColor: Colors.lightBlue[100], // Set background color
                      title: Text(
                        "Are you sure?",
                        textAlign: TextAlign.center, // Align title text to center
                        style: TextStyle(
                          fontSize: 24, // Increase font size
                          color: Colors.black, // Set text color
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min, // Set column to wrap content
                        children: [
                          Text(
                            "This action cannot be undone.",
                            textAlign: TextAlign.center, // Align content text to center
                            style: TextStyle(
                              fontSize: 18, // Increase font size
                              color: Colors.black, // Set text color
                            ),
                          ),
                          SizedBox(height: 20), // Add space between texts and buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Align buttons evenly
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                    fontSize: 18, // Increase font size
                                    color: Colors.black, // Set text color
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => testsuccessful(username: widget.username, name: widget.name)),
                                  );

                                },
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                    fontSize: 18, // Increase font size
                                    color: Colors.black, // Set text color
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text(
                'Submit >',
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
