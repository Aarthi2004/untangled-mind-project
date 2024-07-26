import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/common.dart';

class TestResult extends StatefulWidget {
  final String? userId;
  final String? name;
  final String? date;
  final String? subtopicName;
  final String? subtopicId;

  const TestResult({Key? key, this.userId, this.date, this.subtopicName, this.subtopicId, this.name}) : super(key: key);

  @override
  _TestResultState createState() => _TestResultState();
}

class _TestResultState extends State<TestResult> {
  List<dynamic> answers = [];

  @override
  void initState() {
    super.initState();
    fetchTestResults();
  }

  Future<void> fetchTestResults() async {
    try {
      // Check if userId, date, and subtopicId are not null
      if (widget.userId != null && widget.date != null && widget.subtopicId != null) {
        final Uri uri = Uri.parse('$gettopicans?user_id=${widget.userId ?? ''}&date=${widget.date ?? ''}&subtopic_id=${widget.subtopicId ?? ''}');
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          setState(() {
            answers = json.decode(response.body)['data'];
          });
        } else {
          print('Failed to load test results');
        }
      } else {
        print('One or more parameters (userId, date, subtopicId) are null.');
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
      body: answers.isEmpty
          ? Center(
        child: Text(
          'No answers available for this date.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: answers.length,
        itemBuilder: (context, index) {
          final answer = answers[index];
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question: ${answer['question_id'] ?? 'N/A'}',
                  // Add null check for 'question_id'
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  answer['question'] ?? 'N/A',
                  // Add null check for 'question_text'
                  style: TextStyle(fontSize: 19),
                ),
                SizedBox(height: 15),
                Text(
                  'Answer:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 13),
                Text(
                  answer['answer'] ?? 'N/A',
                  // Add null check for 'user_answer'
                  style: TextStyle(fontSize: 19),
                ),
                Divider(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[100],
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Addadvise(
                  userId: widget.userId!,
                  name: widget.name!,
                  date: widget.date,
                  subtopicName: widget.subtopicName!,
                ),
              ),
            );
          },
          child: Container(
            height: 50.0,
            child: Center(
              child: Text(
                'Add Advice',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Addadvise extends StatefulWidget {
  final String? userId;
  final String? name;
  final String? date;
  final String? subtopicName;
  const Addadvise({Key? key, this.userId, this.date, this.subtopicName, this.name}) : super(key: key);

  @override
  State<Addadvise> createState() => _AddadviseState();
}

class _AddadviseState extends State<Addadvise> {
  TextEditingController _suggestionController = TextEditingController();

  Future<void> _postSuggestion() async {
    // Retrieve data from the form
    String userId = widget.userId ?? "";
    String suggestion = _suggestionController.text.trim();

    // Check if suggestion is not empty
    if (suggestion.isNotEmpty) {
      // Make POST request to PHP API endpoint
      final response = await http.post(
        Uri.parse(addsuggestion),
        body: {
          'user_id': userId,
          'suggestion': suggestion,
        },
      );

      // Check response status
      if (response.statusCode == 200) {
        // Parse response JSON
        Map<String, dynamic> data = json.decode(response.body);
        if (data['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Advise has been added'),
            ),
          );
          // Suggestion added successfully, navigate back
          Navigator.of(context).pop();
        } else {
          // Display error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message']),
            ),
          );
        }
      } else {
        // Display error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: Failed to post suggestion. Please try again later.'),
          ),
        );
      }
    } else {
      // Display error message if suggestion is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a suggestion.'),
        ),
      );
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
          'Add Advice',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.7,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' Add Advice',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _suggestionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 100.0),
              ),
              maxLines: null, // Allow multiple lines of text
              textAlignVertical: TextAlignVertical.top,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[100],
        child: GestureDetector(
          onTap: _postSuggestion,
          child: Container(
            height: 50.0,
            child: Center(
              child: Text(
                'Post',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


