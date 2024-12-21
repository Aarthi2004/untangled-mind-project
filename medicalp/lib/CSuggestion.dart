import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medicalp/common.dart';

class CSuggestion extends StatefulWidget {
  final String username;

  const CSuggestion({Key? key, required this.username}) : super(key: key);

  @override
  _CSuggestionState createState() => _CSuggestionState();
}

class _CSuggestionState extends State<CSuggestion> {
  List<String> suggestions = [];

  @override
  void initState() {
    super.initState();
    _fetchSuggestions();
  }

  Future<void> _fetchSuggestions() async {
    try {
      Uri apiUrl = Uri.parse(getsuggestions); // Replace with your PHP URL
      apiUrl = apiUrl.replace(queryParameters: {'user_id': widget.username});
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status']) {
          List<dynamic> suggestionsData = data['data'];
          List<String> fetchedSuggestions =
          suggestionsData.map((e) => e['suggestion'] as String).toList();
          setState(() {
            suggestions = fetchedSuggestions;
          });
        } else {
          // Handle error message if needed
        }
      } else {
        // Handle errors
      }
    } catch (e) {
      // Handle exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.lightBlue[100],
        title: Text(
          'Suggestions',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20), // EdgeInsets for edge insets
        child: ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(suggestions[index]),
                  ),
                ),
                SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
