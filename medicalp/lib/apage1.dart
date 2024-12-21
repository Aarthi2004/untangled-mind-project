import 'package:flutter/material.dart';
import 'package:medicalp/a_adddoctor.dart';
import 'package:medicalp/a_addcaretaker.dart';
import 'package:medicalp/a_adminprofile.dart';
import 'package:medicalp/a_doctorlist.dart';
import 'package:medicalp/a_edittopic.dart';
import 'package:medicalp/admin.dart';
import 'a_ctlist.dart';
import 'add_topics.dart';

class Apage1 extends StatelessWidget {
  const Apage1({Key? key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop:() async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder:(context)=> AdminPage()),
            ModalRoute.withName('/',)
          );
          return false;
        },
    child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[100],
        elevation: 0,
        toolbarHeight: 110,
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
                    'HELLO,',
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'DOCTOR',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: GestureDetector(
                onTap: () {
                  // Navigate to another page when the image is tapped
                  // Replace `AnotherPage()` with the desired destination page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => A_adminprofile()),
                  );
                },
                child: Image.asset(
                  'assets/Ellipse123.png',
                  width: 70,
                  height: 80,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 25),
                  backgroundColor: Colors.blue[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Adddoctor()),
                  );
                },
                child: Text(
                  'ADD DOCTORS',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              SizedBox(height: 70),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 25),
                  backgroundColor: Colors.blue[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Doctorslist()),
                  );
                },
                child: Text(
                  'DOCTORS LIST',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              SizedBox(height: 70),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 90, vertical: 25),
                  backgroundColor: Colors.blue[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCaretaker()),
                  );
                },
                child: Text(
                  'ADD CARETAKERS',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              SizedBox(height: 70),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 25),
                  backgroundColor: Colors.blue[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ctlist ()),
                  );
                },
                child: Text(
                  'CARETAKER LIST',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[100],
        height: 80.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Addtopic(),
                  ),
                );
              },
              child: Text(
                'ADD TOPIC',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => A_edittopic(),
                  ),
                );
              },
              child: Text(
                'EDIT TOPIC',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
