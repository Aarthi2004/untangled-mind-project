import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicalp/common.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class Updatevideo extends StatefulWidget {
  final String subtopicName;
  final double subtopicId;
  final VoidCallback onUpdate;

  const Updatevideo({
    Key? key,
    required this.subtopicName,
    required this.subtopicId,
    required this.onUpdate
  }) : super(key: key);

  @override
  State<Updatevideo> createState() => _UpdatevideoState();
}

class _UpdatevideoState extends State<Updatevideo> {
  VideoPlayerController? _videoPlayerController;
  String? _selectedVideo;
  final TextEditingController _textController = TextEditingController();

  void _pickVideo(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedVideo = pickedFile.path;
        _videoPlayerController = VideoPlayerController.file(File(_selectedVideo!))
          ..initialize().then((_) {
            setState(() {}); // Update the state to refresh the UI
          });
      });
    }
  }

  Future<void> _updateSubtopic() async {
    if (_selectedVideo == null || _textController.text.isEmpty) {
      // Show an error message if video or description is missing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a video and enter a description.')),
      );
      return;
    }

    // Show confirmation dialog
    bool? confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Update'),
        content: Text('Are you sure you want to update the subtopic?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('OK'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Prepare the request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(updatevideo), // Replace with your server URL
    );
    request.fields['subtopic_id'] = widget.subtopicId.toString();
    request.fields['subtopic_name'] = widget.subtopicName;
    request.fields['description'] = _textController.text;
    request.files.add(await http.MultipartFile.fromPath(
      'video',
      _selectedVideo!,
      filename: path.basename(_selectedVideo!),
    ));

    // Send the request
    var response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final result = jsonDecode(responseData);

      if (result['status'] == true) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );

        // Pop the current screen
        Navigator.of(context).pop();
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update the subtopic.')),
      );
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _textController.dispose();
    super.dispose();
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
          'Update videos',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              GestureDetector(
                onTap: () => _pickVideo(context),
                child: Container(
                  width: 350,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: _selectedVideo != null && _videoPlayerController != null
                      ? VideoPlayer(_videoPlayerController!)
                      : Icon(
                    Icons.video_collection_outlined,
                    size: 60,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: 'Enter video description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ),
              // Add other widgets here as needed
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
                onTap: _updateSubtopic,
                child: Text(
                  'Update',
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