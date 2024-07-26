import 'package:flutter/material.dart';
import 'admin.dart';
import 'caretaker.dart';
import 'doctor.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardWidth = screenWidth * 0.8;
    double cardHeight = screenHeight * 0.58;
    double buttonWidth = screenWidth * 0.7;
    double buttonHeight = screenHeight * 0.07;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bluebackground.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  child: Stack(
                    children: [
                      // Background Image inside the Card
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/whitebackground.png'), // Replace with your image path
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/login.png',
                              height: 250,
                              width: 250,
                            ),
                            SizedBox(height: 5),
                            ElevatedButton(
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(Size(buttonWidth, buttonHeight)),
                                backgroundColor: MaterialStateProperty.all(Colors.blue[100]),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                                elevation: MaterialStateProperty.all(5),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DoctorLogin()),
                                );
                              },
                              child: Text(
                                'Doctor Login',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(Size(buttonWidth, buttonHeight)),
                                backgroundColor: MaterialStateProperty.all(Colors.blue[100]),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                                elevation: MaterialStateProperty.all(5),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Caretaker()), // Adjusted to CaretakerLogin
                                );
                              },
                              child: Text(
                                'Caretaker Login',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Are you admin?',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AdminPage()),
                                    );
                                  },
                                  child: Text(
                                    ' Admin',
                                    style: TextStyle(
                                      fontSize: 19.0,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
