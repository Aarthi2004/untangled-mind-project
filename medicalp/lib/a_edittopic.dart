import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/a_editsubtopic.dart';
import 'package:medicalp/c_subtopics.dart';
import 'package:medicalp/common.dart';

class A_edittopic extends StatefulWidget {

  A_edittopic({Key? key}) : super(key: key);

  @override
  _A_edittopicState createState() => _A_edittopicState();
}

class _A_edittopicState extends State<A_edittopic> {
  List<Map<String, dynamic>> topics = [];

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    final response = await http.get(Uri.parse(ctopic));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        topics = List<Map<String, dynamic>>.from(responseData['data']);
        topics.sort((a, b) => a['topic_id'].compareTo(b['topic_id']));
      });
    } else {
      // Handle error
      print('Failed to load topics');
    }
  }

  void updateTopicsList() {
    fetchTopics();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        return false;
      },
      child: Scaffold(
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
            'Topics',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTopicPage(
                            topicId: int.parse(topic['topic_id']),
                            topicName: topic['topic_name'],
                            updateTopicsList: updateTopicsList,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${topic['topic_id']}          ${topic['topic_name']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Image.asset(
                            'assets/edit.png', // Replace 'assets/edit.png' with your image path
                            width: 24, // Adjust the size as needed
                            height: 24, // Adjust the size as needed
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Editsubtopic(
                                  topicId: int.parse(topic['topic_id']),
                                  topicName: topic['topic_name'],
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class EditTopicPage extends StatefulWidget {
  final int topicId;
  final String topicName;
  final Function() updateTopicsList;

  EditTopicPage({
    required this.topicId,
    required this.topicName,
    required this.updateTopicsList,
  });

  @override
  _EditTopicPageState createState() => _EditTopicPageState();
}

class _EditTopicPageState extends State<EditTopicPage> {
  late TextEditingController _topicNameController;

  @override
  void initState() {
    super.initState();
    _topicNameController = TextEditingController(text: widget.topicName);
  }

  @override
  void dispose() {
    _topicNameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    // Construct the URL for the PHP backend
    final url = Uri.parse(edit_topiclist); // Replace with your PHP endpoint

    // Send POST request to update topic
    final response = await http.post(
      url,
      body: {
        'topic_id': widget.topicId.toString(),
        'topic_name': _topicNameController.text,
      },
    );

    // Handle response
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: response.statusCode == 200 ? Text('Success') : Text('Error'),
        content: response.statusCode == 200
            ? Text('Changes saved successfully!')
            : Text('Failed to save changes. Please try again later.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              if (response.statusCode == 200) {
                // If changes were successful, refresh the topics list
                widget.updateTopicsList(); // Call the callback function to update the topics list
                Navigator.pop(context, true); // Pop back to previous page
              }
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
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
          'Topics',
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
                '${widget.topicId}',
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
