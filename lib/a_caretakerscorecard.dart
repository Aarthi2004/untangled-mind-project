import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/common.dart';

class A_caretakerscorecard extends StatefulWidget {
  final String date;
  final String userId;
  final Map<String, int> previousAnswers;

  const A_caretakerscorecard({
    Key? key,
    required this.date,
    required this.userId,
    required this.previousAnswers,
  }) : super(key: key);

  @override
  _A_caretakerscorecardState createState() => _A_caretakerscorecardState();
}

class _A_caretakerscorecardState extends State<A_caretakerscorecard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Future<Map<String, dynamic>> _futureData;
  late int a = 0, b = 0, c = 0, d = 0, e = 0, totalscore = 0;
  late Map<String, int> answerCounts = {};
  TextEditingController suggestionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureData = fetchData(); // Initialize _futureData
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Adjust duration as needed
    );
  }

  Future<Map<String, dynamic>> fetchData() async {
    if (widget.userId == null || widget.date == null) {
      throw Exception('User ID or date is null');
    }

    final Uri uri = Uri.parse('$adminscorecard?user_id=${widget.userId ?? ''}&date=${widget.date ?? ''}');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['status'] == true) {
        dynamic data = responseData['data'];

        if (data is List) {
          if (data.isNotEmpty) {
            Map<String, dynamic> userData = data[0];

            totalscore = userData['total_score'];
            a = userData['A'];
            b = userData['B'];
            c = userData['C'];
            d = userData['D'];
            e = userData['E'];

            answerCounts = {
              'A': a,
              'B': b,
              'C': c,
              'D': d,
              'E': e,
            };

            return {
              'totalScore': totalscore,
              'scoreA': a,
              'scoreB': b,
              'scoreC': c,
              'scoreD': d,
              'scoreE': e,
            };
          } else {
            throw Exception('No data available for the specified user ID and date');
          }
        } else {
          throw Exception('Data is not in the expected format');
        }
      } else {
        throw Exception('Failed to load data: ${responseData['message']}');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  int calculateTotalScore(Map<String, dynamic> scorecard) {
    int totalScore = 0;
    if (widget.previousAnswers != null) {
      for (String key in scorecard.keys) {
        if (key == 'A' || key == 'B' || key == 'C' || key == 'D' || key == 'E') {
          int points = 0;
          switch (key) {
            case 'A':
              points = 4;
              break;
            case 'B':
              points = 3;
              break;
            case 'C':
              points = 2;
              break;
            case 'D':
              points = 1;
              break;
            case 'E':
              points = 0;
              break;
          }
          totalScore += points * (scorecard[key] as int);
        }
      }
    }
    return totalScore;
  }

  Widget buildRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120, // Adjust the width based on your preference
            child: Text(
              '$label',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(width: 35), // Adjust the width based on your preference
          Expanded(
            child: Text(
              value != null ? value.toString() : 'N/A',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Data has been fetched successfully
            // Extract data from snapshot and update state variables
            Map<String, dynamic>? responseData = snapshot.data;
            if (responseData != null) {
              totalscore = responseData['totalScore'] ?? 0;
              a = responseData['scoreA'] ?? 0;
              b = responseData['scoreB'] ?? 0;
              c = responseData['scoreC'] ?? 0;
              d = responseData['scoreD'] ?? 0;
              e = responseData['scoreE'] ?? 0;
              answerCounts = {
                'A': a,
                'B': b,
                'C': c,
                'D': d,
                'E': e,
              };
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: CircularProgressIndicator(
                                value: calculateProgressPercentage(),
                                backgroundColor: Colors.grey.withOpacity(0.3),
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF35A29F)),
                                strokeWidth: 10,
                              ),
                            ),
                            Text(
                              '${calculateProgressPercentage()}%',
                              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Options Selected',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 13),
                  buildRow('Option A', answerCounts['A'] ?? a),
                  buildRow('Option B', answerCounts['B'] ?? b),
                  buildRow('Option C', answerCounts['C'] ?? c),
                  buildRow('Option D', answerCounts['D'] ?? d),
                  buildRow('Option E', answerCounts['E'] ?? e),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Add Suggestion',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: suggestionController,
                          decoration: InputDecoration(
                            hintText: 'Type your suggestion here...',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 50, horizontal: 16),
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[100],
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Background color blue 100
                          ),
                          onPressed: () async {
                            await postSuggestion();
                          },
                          child: Text('Post'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  calculateProgressPercentage() {
    return totalscore.toDouble();
  }

  Future<void> postSuggestion() async {
    String userId = widget.userId;
    String date = widget.date;
    String suggestion = suggestionController.text;

    final url = addsuggestion;
    final response = await http.post(
      Uri.parse(url),
      body: {
        'user_id': userId,
        'date': date,
        'suggestion': suggestion,
      },
    );

    if (response.statusCode == 200) {
      // Suggestion posted successfully
      // Show a Snackbar indicating that the suggestion has been added
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Suggestion added successfully'),
      ));

      // You can optionally pop the page here
      Navigator.of(context).pop();
    } else {
      // Suggestion posting failed
      // You can handle the error if needed
      print('Failed to post suggestion: ${response.reasonPhrase}');
    }
  }
}
