import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/a_editvideos.dart';
import 'package:medicalp/c_videos.dart';
import 'package:medicalp/common.dart';

class Editsubtopic extends StatefulWidget {
  final int topicId;
  final String topicName;

  Editsubtopic({
    required this.topicId,
    required this.topicName,
  });

  @override
  _EditsubtopicState createState() => _EditsubtopicState();
}

class _EditsubtopicState extends State<Editsubtopic> {
  List<Map<String, dynamic>> subtopics = [];

  @override
  void initState() {
    super.initState();
    fetchSubtopics(widget.topicName);
  }

  Future<void> fetchSubtopics(String topicName) async {
    try {
      Uri apiUrl = Uri.parse(csubtopic); // Replace with your PHP URL
      final Uri modifiedUrl = apiUrl.replace(queryParameters: {'topic_name': topicName});
      final response = await http.get(modifiedUrl);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          setState(() {
            subtopics = List<Map<String, dynamic>>.from(responseData['data']);
          });
        } else {
          // Handle error
          print('Failed to load subtopics: ${responseData['message']}');
        }
      } else {
        // Handle error
        print('Failed to load subtopics');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error fetching subtopics: $e');
    }
  }

  void updateSubtopicsList() {
    // Call fetchSubtopics to update the subtopics list
    fetchSubtopics(widget.topicName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.blue[100],
        title: Text(
          '${widget.topicName}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: subtopics.length,
                itemBuilder: (context, index) {
                  final subtopic = subtopics[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Editsubtopicpage(
                                subtopicId: double.parse(subtopic['subtopic_id']),
                                subtopicName: subtopic['subtopic_name'],
                                updateSubtopicsList: updateSubtopicsList,
                              ),
                            ),
                          );
                        },

                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${subtopic['subtopic_id']} - ${subtopic['subtopic_name']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Image.asset(
                                'assets/editbluepen.png', // Replace 'assets/edit.png' with your image path
                                width: 24, // Adjust the size as needed
                                height: 24, // Adjust the size as needed
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => A_editvideos(
                                      subtopicId: double.parse(subtopic['subtopic_id']),
                                      subtopicName: subtopic['subtopic_name'],
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      Divider(), // Divider between items
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class Editsubtopicpage extends StatefulWidget {
  final double subtopicId;
  final String subtopicName;
  final Function() updateSubtopicsList;

  Editsubtopicpage({
    required this.subtopicId,
    required this.subtopicName,
    required this.updateSubtopicsList,
  });

  @override
  _EditsubtopicpageState createState() => _EditsubtopicpageState();
}

class _EditsubtopicpageState extends State<Editsubtopicpage> {
  late TextEditingController _topicNameController;

  @override
  void initState() {
    super.initState();
    _topicNameController = TextEditingController(text: widget.subtopicName);
  }

  @override
  void dispose() {
    _topicNameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    // Construct the URL for the PHP backend
    final url = Uri.parse(edit_subtopicslist); // Replace with your PHP endpoint URL

    // Send POST request to update subtopic
    final response = await http.post(
      url,
      body: {
        'subtopic_id': widget.subtopicId.toString(),
        'subtopic_name': _topicNameController.text,
      },
    );

    // Handle response
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == true) {
        // Changes saved successfully
        widget.updateSubtopicsList(); // Call the function to update the subtopics list
        Navigator.pop(context, true); // Pop back to the previous page
      } else {
        // Failed to save changes
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to save changes. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      // Error in HTTP request
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to communicate with the server. Please check your internet connection.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 90,
        backgroundColor: Colors.blue[100],
        title: Text(
          'Edit Subtopic',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          Row(
            children: [
              Text(
                '${widget.subtopicId}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 20), // Add spacing between topic ID and topic name
              Expanded(
                child: TextField(
                  controller: _topicNameController,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Set focused border color to transparent
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Set default border color to black
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[100],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _saveChanges, // Assuming _saveChanges is your save function
                child: Text(
                  'Save',
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
}
