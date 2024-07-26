import 'dart:convert';
import 'cpage3.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/common.dart';

class CPage2 extends StatefulWidget {
  final String username;
  final String name;
  CPage2({required this.username,required this.name});

  @override
  _CPage2State createState() => _CPage2State();
}

class _CPage2State extends State<CPage2> {
  bool _isButtonEnabled = false;

  List<Map<String, dynamic>> _questions = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final response = await http.get(Uri.parse(cpage2questionaries));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      setState(() {
        _questions = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load questions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          'Questionnaires',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
        ),
        backgroundColor: Colors.blue[100],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 650, // Adjust this height as needed
              child: Card(
                margin: EdgeInsets.all(18),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView.builder(
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      final question = _questions[index];
                      return QuestionWithOptions(
                        question: 'Question ${index + 1}:\n${question['question_text']}',
                        options: List<String>.from(question['options']),
                        onChanged: (String? value) {
                          setState(() {
                            _questions[index]['groupValue'] = value;
                            _isButtonEnabled = _areAllQuestionsAnswered();
                          });
                        },
                        groupValue: question['groupValue'], // Group value for this question
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isButtonEnabled
                  ? () async {
                final List<Map<String, dynamic>> scores = _questions.map((question) {
                  return {
                    'Questionids': question['question_id'],
                    'Answer': question['groupValue'],
                  };
                }).toList();

                final answer = {
                  'userId': widget.username,
                  'Score': scores,
                };

                final response = await http.post(
                  Uri.parse(post_ans),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(answer),
                );

                if (response.statusCode == 200) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => cpage3(username: widget.username, name: widget.name)),
                  );
                } else {
                  // Handle error
                  print('Failed to submit data: ${response.body}');
                }
              }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 29),
                backgroundColor: Colors.white, // Background color
              ),
              child: Text(
                'SUBMIT',
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _areAllQuestionsAnswered() {
    for (final question in _questions) {
      if (question['groupValue'] == null) {
        return false;
      }
    }
    return true;
  }
}

class QuestionWithOptions extends StatelessWidget {
  final String question;
  final List<String> options;
  final String? groupValue;
  final void Function(String?) onChanged;

  const QuestionWithOptions({
    Key? key,
    required this.question,
    required this.options,
    required this.onChanged,
    required this.groupValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5), // Add space between question number and question text
        Column(
          children: options.map((option) {
            return RadioListTile<String>(
              title: Text(
                option,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal), // Change font style of options
              ),
              value: option,
              groupValue: groupValue,
              onChanged: onChanged,
              toggleable: true, // Use toggleable to show square radio buttons
              activeColor: Colors.blue, // Customize the color of active radio button
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
