import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:medicalp/a_updatevideos.dart';
import 'package:medicalp/common.dart';
import 'package:video_player/video_player.dart';
import 'a_editvideo_questions.dart';

class A_editvideos extends StatefulWidget {
  final String subtopicName;
  final double subtopicId; // Define subtopicId here


  A_editvideos ({
    required this.subtopicName,
    required this.subtopicId, // Initialize subtopicId in the constructor
  });

  @override
  _A_editvideosState createState() => _A_editvideosState();
}

class _A_editvideosState extends State<A_editvideos > {
  late FlickManager flickManager;
  String? _description;

  @override
  void initState() {
    super.initState();
    _fetchVideoData();
  }

  void _fetchVideoData() async {
    final apiUrl = getvideo;
    final modifiedUrl = Uri.parse(apiUrl).replace(queryParameters: {'subtopic_name': widget.subtopicName});

    try {
      final response = await http.get(modifiedUrl);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final videoUrl = jsonData['video_url'];
        final description = jsonData['description'];

        setState(() {
          flickManager = FlickManager(
            videoPlayerController: VideoPlayerController.network(
              videoUrl.startsWith('uploads/') || videoUrl.startsWith('videos/')
                  ? 'http://$ip/medproject/$videoUrl'
                  : videoUrl,
            ),
          );
          _description = description;
        });
      } else {
        print('Failed to fetch video data');
      }
    } catch (e) {
      print('Error fetching video data: $e');
    }
  }

  void _refreshData() {
    _fetchVideoData();
  }

  @override
  void dispose() {
    flickManager.dispose();
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
          'Videos',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Updatevideo(
                      subtopicName: widget.subtopicName,
                      subtopicId: widget.subtopicId,
                      onUpdate:_refreshData,
                    ),
                  ),
                );
              },
              child: Image.asset(
                'assets/editbluepen.png', // Replace 'assets/icon.png' with your image path
                width: 30,
                height: 30,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 15),
          // Add space between AppBar and text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Subtopic: ${widget.subtopicName}',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(height: 10),
          // Add space between description title and video
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.93, // Set width to 93% of screen width
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 4), // Add black border
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8), // Optional: Add rounded corners if needed
                child: AspectRatio(
                  aspectRatio: 16 / 9, // Set a fixed aspect ratio (16:9)
                  child: flickManager == null
                      ? Center(child: CircularProgressIndicator())
                      : FlickVideoPlayer(
                    flickManager: flickManager!,
                    flickVideoWithControls: FlickVideoWithControls(
                      playerLoadingFallback: Center(
                        child: CircularProgressIndicator(),
                      ),
                      controls: CustomFlickPortraitControls(flickManager: flickManager!),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          // Add space between subtopic name and description title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Description:',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          // Add space between video and description container
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              // Set width to match parent width
              height: 150,
              // Set height to 150 pixels
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1), // Add black border
              ),
              child: Text(
                _description ?? 'Loading...', // Use description from state
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[100],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionPage(
                        subtopicName: widget.subtopicName,
                        subtopicId: widget.subtopicId,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Questions',
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

class CustomFlickPortraitControls extends StatefulWidget {
  final FlickManager flickManager;

  CustomFlickPortraitControls({required this.flickManager});

  @override
  _CustomFlickPortraitControlsState createState() =>
      _CustomFlickPortraitControlsState();
}

class _CustomFlickPortraitControlsState
    extends State<CustomFlickPortraitControls> {
  bool _showControls = true;
  bool _isMuted = false; // Initially set to true to show controls

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showControls = !_showControls; // Toggle the visibility of controls
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: _showControls,
                    child: FlickCurrentPosition(),
                  ),
                  Visibility(
                    visible: _showControls,
                    child: FlickTotalDuration(),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Visibility(
                visible: _showControls,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(), // Add Spacer to create equal space before the first icon
                    IconButton(
                      icon: Icon(Icons.fast_rewind),
                      onPressed: () {
                        widget.flickManager.flickControlManager?.seekBackward(Duration(seconds: 10));
                      },
                    ),
                    SizedBox(width: 30), // Keep your fixed spacing
                    FlickPlayToggle(size: 30), // Play/Pause toggle icon
                    SizedBox(width: 30), // Keep your fixed spacing
                    IconButton(
                      icon: Icon(Icons.fast_forward),
                      onPressed: () {
                        widget.flickManager.flickControlManager?.seekForward(Duration(seconds: 10));
                      },
                    ),
                    Spacer(), // Add Spacer to create equal space after the last icon
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 150,
          left: 0,
          right: 0,
          child: FlickVideoProgressBar(
            flickProgressBarSettings: FlickProgressBarSettings(
              handleRadius: 6,
              height: 2,
              backgroundColor: Color.fromRGBO(216, 216, 216, 0.6),
              bufferedColor: Color.fromRGBO(0, 0, 0, 0.2),
              playedColor: Colors.red,
              handleColor: Colors.red,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Visibility(
            visible: _showControls,
            child: IconButton(
              icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up), // Change icon based on mute status
              onPressed: () {
                setState(() {
                  _isMuted = !_isMuted; // Toggle mute status
                });
                // Mute or unmute audio based on _isMuted value
                if (_isMuted) {
                  // Mute audio
                  widget.flickManager.flickControlManager?.mute();
                } else {
                  // Unmute audio
                  widget.flickManager.flickControlManager?.unmute();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}