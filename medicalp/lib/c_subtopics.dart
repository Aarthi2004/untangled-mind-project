import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/c_videos.dart';
import 'package:medicalp/common.dart';

class C_subtopic extends StatefulWidget {
  final String username;
  final String name;
  final int topicId;
  final String topicName;

  C_subtopic({
    required this.username,
    required this.name,
    required this.topicId,
    required this.topicName,
  });

  @override
  _C_subtopicState createState() => _C_subtopicState();
}

class _C_subtopicState extends State<C_subtopic> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.lightBlue[100],
        title: Text(
          'Subtopics of ${widget.topicName}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      TextButton(
                        onPressed: () {
                          if (subtopic != null && subtopic is Map<String, dynamic>) {
                            String subtopicId;
                            if (subtopic['subtopic_id'] is num) {
                              subtopicId = (subtopic['subtopic_id'] as num).toStringAsFixed(1);
                            } else {
                              subtopicId = double.parse(subtopic['subtopic_id'].toString()).toStringAsFixed(1);
                            }
                            print('Parsed subtopicId: $subtopicId');

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => C_videos(
                                  username: widget.username,
                                  name: widget.name,
                                  subtopicName: subtopic['subtopic_name'] as String,
                                  subtopicId: subtopicId,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          '${subtopic['subtopic_id']} - ${subtopic['subtopic_name']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
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
