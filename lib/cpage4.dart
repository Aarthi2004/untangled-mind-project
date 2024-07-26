import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:medicalp/c_profile.dart';
import 'dart:convert';
import 'package:medicalp/cpage1.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:medicalp/CSuggestion.dart';
import 'package:medicalp/c_topic.dart';
import 'package:medicalp/cpage2.dart';
import 'common.dart';
import 'package:url_launcher/url_launcher.dart';

class CPage4 extends StatefulWidget {
  final String username;
  final String name;

  CPage4({required this.username,required this.name});

  @override
  _CPage4State createState() => _CPage4State();
}

class _CPage4State extends State<CPage4> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  int _selectedIndex = 0;
  List<String> suggestions = [];//suggestions
  String? name;
  bool _isLoading = true; // Add _isLoading variable and initialize to true

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // Total duration for all images to loop
    )..repeat();
    _offsetAnimation = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
    _fetchName();
    _fetchSuggestions();// Call _fetchName method to fetch user's name
  }

  Future<void> _fetchName() async {
    try {
      Uri apiUrl = Uri.parse(nameparsing); // Replace with your PHP URL
      apiUrl = apiUrl.replace(queryParameters: {'user_id': widget.username});
      final response = await http.get(apiUrl);

      print("API called: ${apiUrl.toString()}");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status']) {
          setState(() {
            name = data['data'][0]['Name'];
            print("Fetched name: $name");
          });
        } else {
          print("Error: ${data['message']}");
        }
      } else {
        print("Error: Unable to fetch name.");
      }
    } catch (e) {
      print("Exception: $e");
    }
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
            _isLoading = false;
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
    return WillPopScope(
      onWillPop: () async {
        // Navigate to the login page when the back button is pressed
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => CPage1(username: widget.username, name: widget.name)),
          ModalRoute.withName('/'), // This ensures that PLoginPage becomes the new root
        );
        return false; // Prevents default back button behavior
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 130,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hello,',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        if (name != null)
                          Text(
                            name!,
                            style: TextStyle(fontSize: 26.0),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: GestureDetector(
                      onTap: () async {
                        _openWhatsApp();
                      },
                      child: Image.asset(
                        'assets/image 16.png',
                        width: 40,
                        height: 40,
                      ),
                    ),

                  )
                ],
              ),
            ),
          ),
        ),
        // Inside the SingleChildScrollView containing the body of your Scaffold
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  child: CarouselSlider.builder(
                    itemCount: 5, // Total number of images
                    itemBuilder: (context, index, realIndex) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            _getImagePath(index),
                            width: 327,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Text(
                      'Suggestion',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 140),
                    TextButton(
                      child: Text(
                        'view all',
                        style: TextStyle(fontSize: 18, color: Colors.lightBlue),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CSuggestion(username: widget.username)), // Replace apage2() with the page you want to navigate to
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              // Wrap the ListView.builder in a SizedBox with a fixed height
              SizedBox(
                height: 300, // Adjust the height as needed
                child: SingleChildScrollView( // Wrap the ListView.builder in a SingleChildScrollView
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          child: ListTile(
                            title: Text(suggestions[index]), // Display suggestion
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue[100], // Background color
          items: [
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => C_topic(username: widget.username, name: widget.name)),
                  );
                },
                child: Icon(
                  FluentIcons.video_16_filled, // Icon representing clipboard
                  size: 35,  // Adjust the size as needed
                  color: Colors.black,
                ),
              ),
              label: '', // Set label to empty string if you don't want to display text
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CPage2(username: widget.username, name: widget.name)),
                  );
                },
                child: Icon(
                  FluentIcons.text_bullet_list_square_edit_20_regular, // Icon representing clipboard
                  size: 35, // Adjust the size as needed
                  color: Colors.black,
                ),
              ),
              label: '', // Set label to empty string if you don't want to display text
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => C_profile(username: widget.username, name: widget.name)),
                  );
                },
                child: Icon(
                  FluentIcons.person_square_16_filled, // Icon representing tests
                  size: 35, // Adjust the size as needed
                  color: Colors.black,
                ),
              ),
              label: '', // Set label to empty string if you don't want to display text
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getImagePath(int index) {
    switch (index) {
      case 0:
        return 'assets/image 2.png';
      case 1:
        return 'assets/image 2.png';
      case 2:
        return 'assets/image 2.png';
      case 3:
        return 'assets/image 2.png';
      case 4:
        return 'assets/image 2.png';
      default:
        return '';
    }
  }
}
void _openWhatsApp() async {
  final Uri whatsappUrl = Uri.parse('whatsapp://send?phone=917358732901'); // Replace PHONE_NUMBER with the phone number you want to message
  try {
    await launch(whatsappUrl.toString());
  } catch (e) {
    print('Error launching WhatsApp: $e');
  }
}


