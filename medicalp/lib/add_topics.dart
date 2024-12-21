import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'add_questions.dart';
import 'common.dart';

class Addtopic extends StatefulWidget {
  @override
  _AddtopicState createState() => _AddtopicState();
}

class _AddtopicState extends State<Addtopic> {
  final ImagePicker _picker = ImagePicker();
  File? _videoFile;
  final TextEditingController _topicIdController = TextEditingController();
  final TextEditingController _topicNameController = TextEditingController();
  final TextEditingController _subTopicIdController = TextEditingController();
  final TextEditingController _subTopicNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitData() async {
    if (_videoFile == null ||
        _topicIdController.text.isEmpty ||
        _topicNameController.text.isEmpty ||
        _subTopicIdController.text.isEmpty ||
        _subTopicNameController.text.isEmpty) {
      // Show an error message if required fields are missing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and upload a video')),
      );
      return;
    }

    final uri = Uri.parse(addtopic);
    final request = http.MultipartRequest('POST', uri);

    request.fields['topic_id'] = _topicIdController.text;
    request.fields['topic_name'] = _topicNameController.text;
    request.fields['subtopic_id'] = _subTopicIdController.text;
    request.fields['subtopic_name'] = _subTopicNameController.text;
    request.fields['description'] = _descriptionController.text;

    final mimeTypeData = lookupMimeType(_videoFile!.path, headerBytes: [0xFF, 0xD8])?.split('/');
    request.files.add(
      http.MultipartFile(
        'video',
        _videoFile!.readAsBytes().asStream(),
        _videoFile!.lengthSync(),
        filename: _videoFile!.path.split('/').last,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      ),
    );

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        print('Response body: ${responseData.body}');

        try {
          final responseJson = jsonDecode(responseData.body);

          if (responseJson['success']) {
            // Navigate to the AddQuestions page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddQuestions(),
              ),
            );
          } else {
            // Print error message to console
            print('Error message: ${responseJson['message']}');
          }
        } catch (e) {
          // Print JSON decoding error to console
          print('JSON decoding error: $e');
        }
      } else {
        // Print HTTP error status to console
        print('Failed to submit data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Print network or other errors to console
      print('Network or other error: $e');
    }
  }

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
          'Add Topics',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Topic_ID',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 60),
                  Container(
                    width: 230,
                    child: TextField(
                      controller: _topicIdController,
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
                    'Topic Name',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 35),
                  Container(
                    width: 230,
                    child: TextField(
                      controller: _topicNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Topic Name',
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    'Sub Topic ID',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 31),
                  Container(
                    width: 230,
                    child: TextField(
                      controller: _subTopicIdController,
                      decoration: InputDecoration(
                        hintText: 'Enter Sub Topic ID',
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                  SizedBox(width: 5),
                  Container(
                    width: 230,
                    child: TextField(
                      controller: _subTopicNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Sub Topic Name',
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Added space between previous elements and new ones
              Row(
                children: [
                  Text(
                    'Video',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 70), // Adjust spacing as needed
                  IconButton(
                    onPressed: _pickVideo,
                    icon: Icon(Icons.add),
                  ),
                  SizedBox(width: 10), // Adjust spacing as needed
                  TextButton(
                    onPressed: _pickVideo,
                    child: Text(
                      'Upload Video',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                'Description',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter Description',
                    contentPadding: EdgeInsets.symmetric(vertical: 50, horizontal: 50),
                    border: OutlineInputBorder(),
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
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _submitData,
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
}
