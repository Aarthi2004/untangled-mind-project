import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flick_video_player/flick_video_player.dart';
import 'package:medicalp/c_topic_qns_test.dart';
import 'package:medicalp/common.dart';
import 'package:video_player/video_player.dart';

class C_videos extends StatefulWidget {
  final String subtopicName;
  final String username;
  final String name;
  final String subtopicId;

  C_videos({
    required this.username,
    required this.name,
    required this.subtopicName,
    required this.subtopicId,
  });

  @override
  _C_videosState createState() => _C_videosState();
}

class _C_videosState extends State<C_videos> {
  FlickManager? flickManager;
  String? _description;

  @override
  void initState() {
    super.initState();
    print('Subtopic Name: ${widget.subtopicName}');
    print('Subtopic ID: ${widget.subtopicId}');
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

  @override
  void dispose() {
    flickManager?.dispose();
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${widget.subtopicId}: ${widget.subtopicName}',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.93,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Description:',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              height: 300,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _description ?? 'Loading...',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16),
                ),
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
                      builder: (context) => ttq1(
                        subtopicName: widget.subtopicName,
                        subtopicId: widget.subtopicId,
                        username: widget.username,
                        name: widget.name,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Take Test',
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
  _CustomFlickPortraitControlsState createState() => _CustomFlickPortraitControlsState();
}

class _CustomFlickPortraitControlsState extends State<CustomFlickPortraitControls> {
  bool _showControls = true;
  bool _isMuted = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showControls = !_showControls;
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
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.fast_rewind),
                      onPressed: () {
                        widget.flickManager.flickControlManager?.seekBackward(Duration(seconds: 10));
                      },
                    ),
                    SizedBox(width: 30),
                    FlickPlayToggle(size: 30),
                    SizedBox(width: 30),
                    IconButton(
                      icon: Icon(Icons.fast_forward),
                      onPressed: () {
                        widget.flickManager.flickControlManager?.seekForward(Duration(seconds: 10));
                      },
                    ),
                    Spacer(),
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
              icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
              onPressed: () {
                setState(() {
                  _isMuted = !_isMuted;
                });
                if (_isMuted) {
                  widget.flickManager.flickControlManager?.mute();
                } else {
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
