import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/apage1.dart';
import 'package:medicalp/common.dart';

class AddQuestions extends StatelessWidget {
  final TextEditingController subtopicIdController = TextEditingController();
  final TextEditingController subtopicNameController = TextEditingController();
  final TextEditingController questionIdController1 = TextEditingController();
  final TextEditingController questionTextController1 = TextEditingController();
  final TextEditingController optionAController1 = TextEditingController();
  final TextEditingController optionBController1 = TextEditingController();
  final TextEditingController optionCController1 = TextEditingController();
  final TextEditingController optionDController1 = TextEditingController();
  final TextEditingController questionIdController2 = TextEditingController();
  final TextEditingController questionTextController2 = TextEditingController();
  final TextEditingController optionAController2 = TextEditingController();
  final TextEditingController optionBController2 = TextEditingController();
  final TextEditingController optionCController2 = TextEditingController();
  final TextEditingController optionDController2 = TextEditingController();
  final TextEditingController questionIdController3 = TextEditingController();
  final TextEditingController questionTextController3 = TextEditingController();
  final TextEditingController optionAController3 = TextEditingController();
  final TextEditingController optionBController3 = TextEditingController();
  final TextEditingController optionCController3 = TextEditingController();
  final TextEditingController optionDController3 = TextEditingController();
  final TextEditingController questionIdController4 = TextEditingController();
  final TextEditingController questionTextController4 = TextEditingController();
  final TextEditingController optionAController4 = TextEditingController();
  final TextEditingController optionBController4 = TextEditingController();
  final TextEditingController optionCController4 = TextEditingController();
  final TextEditingController optionDController4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.only(left: 20),
          icon: Icon(Icons.arrow_back_ios, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 80,
        backgroundColor: Colors.blue[100],
        title: Text(
          'Add Questions',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Sub Topic_ID',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 35),
                Expanded(
                  child: TextField(
                    controller: subtopicIdController,
                    decoration: InputDecoration(
                      hintText: 'Enter Topic ID',
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Sub Topic Name',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: subtopicNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Topic Name',
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            buildQuestionFields(1),
            buildQuestionFields(2),
            buildQuestionFields(3),
            buildQuestionFields(4),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[100],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  // Create subtopic details
                  var subtopicDetails = {
                    'subtopic_id': subtopicIdController.text,
                    'subtopic_name': subtopicNameController.text,
                  };

                  // Create list to store questions
                  List<Map<String, String>> questionsList = [
                    {
                      'question_id': questionIdController1.text,
                      'question': questionTextController1.text,
                      'option_a': optionAController1.text,
                      'option_b': optionBController1.text,
                      'option_c': optionCController1.text,
                      'option_d': optionDController1.text,
                    },
                    {
                      'question_id': questionIdController2.text,
                      'question': questionTextController2.text,
                      'option_a': optionAController2.text,
                      'option_b': optionBController2.text,
                      'option_c': optionCController2.text,
                      'option_d': optionDController2.text,
                    },
                    {
                      'question_id': questionIdController3.text,
                      'question': questionTextController3.text,
                      'option_a': optionAController3.text,
                      'option_b': optionBController3.text,
                      'option_c': optionCController3.text,
                      'option_d': optionDController3.text,
                    },
                    {
                      'question_id': questionIdController4.text,
                      'question': questionTextController4.text,
                      'option_a': optionAController4.text,
                      'option_b': optionBController4.text,
                      'option_c': optionCController4.text,
                      'option_d': optionDController4.text,
                    },
                  ];

                  // Create payload
                  var payload = {
                    'subtopic_id': subtopicIdController.text,
                    'subtopic_name': subtopicNameController.text,
                    'questions': questionsList,
                  };

                  // Convert payload to JSON
                  var jsonData = jsonEncode(payload);

                  // Send POST request
                  http.post(
                    Uri.parse(addtopicquestions),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonData,
                  ).then((response) {
                    print('Response status code: ${response.statusCode}'); // Print the status code for debugging
                    if (response.statusCode == 200) {
                      // Handle success response
                      print('Data saved successfully.');
                      // Check if the dialog is already displayed
                      if (Navigator.of(context).canPop()) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Success"),
                              content: Text("Data saved successfully."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Navigate to Apage1
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Apage1()),
                                    );
                                  },
                                  child: Text("OK"),
                                )
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      print('Failed to save data. Status code: ${response.statusCode}');
                    }
                  }).catchError((error) {
                    // Handle error
                    print('An error occurred: $error');
                  });
                },
                child: Text(
                  'Submit',
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

  Widget buildQuestionFields(int questionNumber) {
    late TextEditingController questionIdController;
    late TextEditingController questionTextController;
    late TextEditingController optionAController;
    late TextEditingController optionBController;
    late TextEditingController optionCController;
    late TextEditingController optionDController;

    switch (questionNumber) {
      case 1:
        questionIdController = questionIdController1;
        questionTextController = questionTextController1;
        optionAController = optionAController1;
        optionBController = optionBController1;
        optionCController = optionCController1;
        optionDController = optionDController1;
        break;
      case 2:
        questionIdController = questionIdController2;
        questionTextController = questionTextController2;
        optionAController = optionAController2;
        optionBController = optionBController2;
        optionCController = optionCController2;
        optionDController = optionDController2;
        break;
      case 3:
        questionIdController = questionIdController3;
        questionTextController = questionTextController3;
        optionAController = optionAController3;
        optionBController = optionBController3;
        optionCController = optionCController3;
        optionDController = optionDController3;
        break;
      case 4:
        questionIdController = questionIdController4;
        questionTextController = questionTextController4;
        optionAController = optionAController4;
        optionBController = optionBController4;
        optionCController = optionCController4;
        optionDController = optionDController4;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            Text(
              'Question_ID',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(width: 11),
            Expanded(
              child: TextField(
                controller: questionIdController,
                decoration: InputDecoration(
                  hintText: 'Enter Question ID',
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 15),
            Container(
              width: 300,
              child: TextField(
                controller: questionTextController,
                decoration: InputDecoration(
                  hintText: 'Enter the question',
                  contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Options',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 15),
            buildOptionTextField(optionAController),
            buildOptionTextField(optionBController),
            buildOptionTextField(optionCController),
            buildOptionTextField(optionDController),
          ],
        ),
      ],
    );
  }

  Widget buildOptionTextField(TextEditingController controller) {
    return Container(
      width: 300,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Enter the option',
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Add Questions',
    home: AddQuestions(),
  ));
}