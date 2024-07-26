import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuestionPage extends StatefulWidget {
  final String subtopicName;
  final double subtopicId;

  QuestionPage({
    required this.subtopicName,
    required this.subtopicId,
  });

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<Map<String, dynamic>> _questions = [];

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Call the PHP API to fetch questions and options
    fetchQuestions();
  }

  void updateQuestionData(int index, Map<String, dynamic> updatedData) {
    setState(() {
      _questions[index] = {
        'question': updatedData['question'],
        'option_a': updatedData['options'][0],
        'option_b': updatedData['options'][1],
        'option_c': updatedData['options'][2],
        'option_d': updatedData['options'][3],
      }; // Replace the existing question map with the updated data
      _isButtonEnabled = _areAllQuestionsAnswered();
    });
  }

  void fetchQuestions() async {
    // Construct the API endpoint URL with the subtopic name
    final url = Uri.parse(
        'http://192.168.252.138:80/medproject/videoquestions.php?subtopic_name=${widget.subtopicName}');
    // Make a GET request to the PHP API
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonData = jsonDecode(response.body);
      if (jsonData['status'] == true) {
        setState(() {
          _questions = List<Map<String, dynamic>>.from(jsonData['data']);
          _isButtonEnabled = _areAllQuestionsAnswered();
        });
      } else {
        // Handle API error
        print('Error: ${jsonData['message']}');
      }
    } else {
      // Handle HTTP error
      print('HTTP Error: ${response.reasonPhrase}');
    }
  }

  bool _areAllQuestionsAnswered() {
    // Check if all questions have been answered
    for (var question in _questions) {
      if (question['groupValue'] == null) {
        return false;
      }
    }
    return true;
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
          'Videos',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final question = _questions[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                dense: true, // This reduces the vertical padding
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${index + 1}:',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                        height: 8), // Add some vertical space between the question index and text
                    Text(
                      '${question['question'] ?? ""}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Options',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionDetailPage(
                              subtopicName: widget.subtopicName,
                              subtopicId: widget.subtopicId,
                              questionId: index + 1, // Pass the correct question index
                              question: question['question'] ?? "",
                              options: [
                                question['option_a'] ?? "",
                                question['option_b'] ?? "",
                                question['option_c'] ?? "",
                                question['option_d'] ?? "",
                              ],
                              onUpdate: (updatedData) =>
                                  updateQuestionData(index, updatedData),
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/edit.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
              ),
              ...List.generate(
                4,
                    (optionIndex) {
                  final optionKey = 'option_${String.fromCharCode(97 + optionIndex)}';
                  final optionValue = question[optionKey] ?? "";
                  return ListTile(
                    leading: Text(
                      '${optionIndex + 1}',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                    title: Text(optionValue),
                  );
                },
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}

class QuestionDetailPage extends StatefulWidget {
  final String subtopicName;
  final double subtopicId;
  final int questionId;
  final String question;
  final List<String>? options;
  final Function(Map<String, dynamic>) onUpdate; // Callback function

  QuestionDetailPage({
    required this.subtopicName,
    required this.subtopicId,
    required this.questionId,
    required this.question,
    this.options,
    required this.onUpdate, // Pass the callback function
  });

  @override
  _QuestionDetailPageState createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  late TextEditingController _questionController;
  late List<TextEditingController> _optionControllers;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question);
    _optionControllers = List.generate(
      widget.options?.length ?? 0, // Use null-aware operator to access length safely
          (index) => TextEditingController(text: widget.options?[index] ?? ''), // Use null-aware operator to access options safely
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveQuestion(BuildContext context) async {
    // Construct the request body as a JSON object
    Map<String, dynamic> requestBody = {
      'subtopic_id': widget.subtopicId.toString(),
      'question_id': widget.questionId.toString(),
      'question': _questionController.text,
      'options': _optionControllers.map((controller) => controller.text).toList(),
    };

    print('Request Body: $requestBody'); // Print the request body for debugging

    try {
      // Send the POST request with JSON data
      final response = await http.post(
        Uri.parse('http://192.168.252.138:80/medproject/edit_topicques.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      // Handle the response...
      if (response.statusCode == 200) {
        // If the request was successful, update the UI with the new data
        widget.onUpdate(requestBody);

        // Navigate back to the previous screen
        Navigator.pop(context);
      } else {
        // Handle HTTP error
        print('HTTP Error: ${response.reasonPhrase}');
        // Show a snackbar or dialog to inform the user about the error
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
      // Show a snackbar or dialog to inform the user about the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
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
          'Edit Questions',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,fontWeight: FontWeight.normal
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _questionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter the question here',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Options:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...List.generate(
                _optionControllers.length,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _optionControllers[index],
                          decoration: InputDecoration(
                            hintText: 'Option ${String.fromCharCode(97 + index)}',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[100],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _saveQuestion(context),
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
