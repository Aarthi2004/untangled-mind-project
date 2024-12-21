import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/a_caretakerscorecard.dart';
import 'package:medicalp/common.dart';

class A_dailyquestionaries extends StatefulWidget {
  final String? userId;
  final String? name;

  const A_dailyquestionaries({Key? key, required this.userId, required this.name}) : super(key: key);

  @override
  _A_dailyquestionariesState createState() => _A_dailyquestionariesState();
}

class _A_dailyquestionariesState extends State<A_dailyquestionaries> {
  List<String> datesFromDatabase = [];

  @override
  void initState() {
    super.initState();
    fetchQuestionnaireDates();
  }

  Future<void> fetchQuestionnaireDates() async {
    try {
      final Uri uri = Uri.parse('$date?user_id=${widget.userId ?? ''}');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          setState(() {
            datesFromDatabase = List<String>.from(responseData['data'].map((date) => date['date']));
          });
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Failed to fetch questionnaire dates. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching questionnaire dates: $e');
      // Handle the error as needed
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
          'Daily Questionnaires',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: datesFromDatabase.map((date) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => A_testans(
                            userId: widget.userId!,
                            name: widget.name!,
                            date: date,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 350,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 48.0),
                              child: Text(
                                date,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class A_testans extends StatefulWidget {
  final String date;
  final String userId;
  final String name;

  const A_testans({Key? key, required this.date, required this.userId, required this.name}) : super(key: key);

  @override
  _A_testansState createState() => _A_testansState();
}

class _A_testansState extends State<A_testans> {
  List<Map<String, dynamic>> answers = [];
  late Map<String, int> answerCounts;

  @override
  void initState() {
    super.initState();
    answerCounts = {};
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      fetchAnswers();
    });
  }

  Future<void> fetchAnswers() async {
    try {
      final Uri uri = Uri.parse('$get_ans?user_id=${widget.userId ?? ''}&date=${widget.date ?? ''}');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          setState(() {
            answers = List<Map<String, dynamic>>.from(responseData['data']);
            countAnswers();
          });
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Failed to fetch answers. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching answers: $e');
    }
  }


  void countAnswers() {
    for (final answer in answers) {
      final userAnswer = answer['user_answer'];
      answerCounts.update(userAnswer, (value) => value + 1, ifAbsent: () => 1);
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
          'Date - ${widget.date}',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
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
                  'Question: ${answer['question_id']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  answer['question_text'],
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
                  answer['user_answer'],
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
                builder: (context) => A_caretakerscorecard(
                  userId: widget.userId,
                  date: widget.date,
                  previousAnswers: answerCounts,
                ),
              ),
            );
          },
          child: Container(
            height: 50.0,
            child: Center(
              child: Text(
                'View Score',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

