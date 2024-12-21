import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/c_subtopics.dart';
import 'package:medicalp/common.dart';

class C_topic extends StatefulWidget {
  final String username;
  final String name;
  C_topic({required this.username, required this.name});

  @override
  _C_topicState createState() => _C_topicState();
}

class _C_topicState extends State<C_topic> {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Pop the current route only
        Navigator.pop(context);
        // Return false to prevent the default back navigation behavior
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
          backgroundColor: Colors.lightBlue[100],
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
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => C_subtopic(
                            username: widget.username,
                            name: widget.name,
                            topicId: int.parse(topic['topic_id']),

                            // Pass the actual value of topic_id
                            topicName: topic['topic_name'],
                          ),
                        ),
                      );
                    },


                    child: Text(
                      '${topic['topic_id']} ${topic['topic_name']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
