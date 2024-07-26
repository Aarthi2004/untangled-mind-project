import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:medicalp/common.dart';

class ttq1 extends StatefulWidget {
  final String subtopicId;
  final String subtopicName;
  final String username;
  final String name;
  ttq1({
    required this.username,
    required this.name,
    required this.subtopicName,
    required this.subtopicId,
  });

  @override
  _ttq1State createState() => _ttq1State();
}

class _ttq1State extends State<ttq1> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  List<String?> selectedOptions = [];
  bool isLoading = true;
  bool answerSelected = false;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final apiUrl = videoqns;
    final modifiedUrl = Uri.parse(apiUrl).replace(queryParameters: {'subtopic_name': widget.subtopicName}).toString();

    try {
      final response = await http.get(Uri.parse(modifiedUrl)); // Corrected
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic>? data = jsonData['data'];

        if (data != null && data.isNotEmpty) {
          setState(() {
            questions = List<Map<String, dynamic>>.from(data);
            selectedOptions = List<String?>.filled(questions.length, null);
            isLoading = false;
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('No Questions'),
                content: Text('There are no questions available for this subtopic.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
            barrierDismissible: false, // Prevent dialog dismissal on outside tap
          );
          setState(() {
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to fetch questions (${response.statusCode})');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void selectAnswer(String optionText) {
    setState(() {
      selectedOptions[currentQuestionIndex] = optionText;
      answerSelected = true;
    });
  }

  Future<void> submitAnswers() async {
    final url = topicans;

    try {
      print("Submitting answers with the following data:");
      print("user_id: ${widget.username}");
      print("subtopic_id: ${widget.subtopicId}");
      print("subtopic_name: ${widget.subtopicName}");
      print("answer1: ${selectedOptions[0] ?? ''}");
      print("answer2: ${selectedOptions[1] ?? ''}");
      print("answer3: ${selectedOptions[2] ?? ''}");
      print("answer4: ${selectedOptions[3] ?? ''}");

      final response = await http.post(
        Uri.parse(url),
        body: {
          'user_id': widget.username, // Replace with actual user ID
          'subtopic_id': widget.subtopicId.toString(),
          'subtopic_name': widget.subtopicName,
          'question1': '1', // Question number
          'answer1': selectedOptions[0] ?? '', // Selected answer
          'question2': '2', // Question number
          'answer2': selectedOptions[1] ?? '', // Selected answer
          'question3': '3', // Question number
          'answer3': selectedOptions[2] ?? '', // Selected answer
          'question4': '4', // Question number
          'answer4': selectedOptions[3] ?? '', // Selected answer
        },
      );

      final responseData = jsonDecode(response.body);
      if (responseData['status']) {
        showSuccessDialog(); // Show success dialog upon successful submission
      } else {
        // Handle error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(responseData['error']),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to submit answers.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Answers saved successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Pop back to previous screen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.blue[100],
        title: Text(
          'TAKE TEST',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : questions.isEmpty
          ? SizedBox() // Render an empty container if there are no questions
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Question ${currentQuestionIndex + 1}:',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildQuestion(questions[currentQuestionIndex]),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          child: Container(
            height: 70.0,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentQuestionIndex > 0) // Render the "Previous" button if it's not the first question
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentQuestionIndex--;
                        answerSelected = false;
                      });
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
                Spacer(), // Add spacer to push "Next" button to the right
                GestureDetector(
                  onTap: answerSelected
                      ? () {
                    if (currentQuestionIndex < questions.length - 1) {
                      setState(() {
                        currentQuestionIndex++;
                        answerSelected = false;
                      });
                    } else {
                      // Submit answers when reached the last question
                      submitAnswers();
                    }
                  }
                      : null,
                  child: Text(
                    currentQuestionIndex < questions.length - 1
                        ? 'Next  >'
                        : 'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
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

  Widget buildQuestion(Map<String, dynamic> questionData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          questionData['question'],
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        Column(
          children: [
            buildOption(0, questionData['option_a']),
            buildOption(1, questionData['option_b']),
            buildOption(2, questionData['option_c']),
            buildOption(3, questionData['option_d']),
          ],
        ),
      ],
    );
  }

  Widget buildOption(int index, String optionText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the top
        children: [
          GestureDetector(
            onTap: () {
              selectAnswer(optionText); // Call selectAnswer function
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedOptions[currentQuestionIndex] == optionText
                      ? Colors.black
                      : Colors.black,
                  width: 2,
                ),
                color: selectedOptions[currentQuestionIndex] == optionText
                    ? Colors.blue[100]
                    : Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              optionText,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
