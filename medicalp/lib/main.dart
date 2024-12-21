import 'package:flutter/material.dart';
import 'package:medicalp/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent, // Set Scaffold background color to transparent
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bluebackground.jpg"), // Replace with your background image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/img.png', // Replace this with your actual image path
                width: screenWidth * 0.7, // Adjust width as a percentage of screen width
                height: screenHeight * 0.4, // Adjust height as a percentage of screen height
              ),
              SizedBox(height: screenHeight * 0.01), // Adjust spacing as a percentage of screen height
              Text(
                'UNTANGLED MIND',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.06, // Adjust font size as a percentage of screen width
                ),
              ),
              SizedBox(height: screenHeight * 0.1), // Adjust spacing as a percentage of screen height
              Container(
                height: screenHeight * 0.1, // Adjust height as a percentage of screen height
                width: screenWidth * 0.8, // Adjust width as a percentage of screen width
                child: ElevatedButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(width: 1, color: Colors.transparent)),
                    overlayColor: MaterialStateProperty.all(Colors.black),
                    elevation: MaterialStateProperty.all(20),
                    backgroundColor: MaterialStateProperty.all(Colors.lightBlue[100]),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenHeight * 0.05), // Adjust borderRadius as a percentage of screen height
                    )),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Text(
                    'GET STARTED',
                    style: TextStyle(fontSize: screenWidth * 0.06, color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
