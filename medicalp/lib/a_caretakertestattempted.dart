import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/a_testresult.dart';
import 'package:medicalp/common.dart';

class TestAttempted extends StatefulWidget {
  final String? userId;
  final String? name;

  const TestAttempted({Key? key, required this.userId, required this.name}) : super(key: key);

  @override
  State<TestAttempted> createState() => _TestAttemptedState();
}

class _TestAttemptedState extends State<TestAttempted> {
  List<Map<String, dynamic>> testResults = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final Uri uri = Uri.parse('$admintopictestdate?user_id=${widget.userId ?? ''}');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);

        if (data['success']) {
          final List<dynamic> dataList = data['data'];
          setState(() {
            testResults = dataList.map((item) => Map<String, dynamic>.from(item)).toList();
          });

          // Debug print statements
          for (var result in testResults) {
            print('subtopicId: ${result['subtopic_id']}, subtopicName: ${result['subtopic_name']}');
          }
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Colors.blue[100],
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.only(left: 30),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 32,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Test Results',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.7,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: testResults.length,
        itemBuilder: (context, index) {
          final subtopicId = testResults[index]['subtopic_id']?.toString() ?? ''; // Ensure non-nullable String
          final subtopicName = testResults[index]['subtopic_name'];
          final date = testResults[index]['date'];

          // Debug print statements
          print('subtopicId: $subtopicId, subtopicName: $subtopicName');

          return Column(
            children: <Widget>[
              ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$subtopicId: ${subtopicName ?? 'No Name'}',
                      style: TextStyle(
                        fontSize: 18, // Adjust text size here
                        fontWeight: FontWeight.normal, // Add font weight if needed
                      ),
                    ),
                    SizedBox(height: 8), // Add spacing between subtopic and date
                    Text(
                      date ?? '',
                      style: TextStyle(
                        fontSize: 18, // Adjust text size here
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TestResult(
                        userId: widget.userId ?? '', // Ensure non-nullable String
                        name: widget.name ?? '', // Ensure non-nullable String
                        date: date ?? '', // Ensure non-nullable String
                        subtopicName: subtopicName ?? '', // Ensure non-nullable String
                        subtopicId: subtopicId,
                      ),
                    ),
                  );
                },
              ),
              if (index != testResults.length - 1) Divider(), // Add Divider if not the last item
            ],
          );
        },
      ),
    );
  }
}
