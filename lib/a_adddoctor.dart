import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:medicalp/common.dart';

class Adddoctor extends StatefulWidget {
  @override
  _AdddoctorState createState() => _AdddoctorState();
}

class _AdddoctorState extends State<Adddoctor> {
  File? _image;

  final _picker = ImagePicker();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image.')),
      );
      return;
    }

    // Convert selected image to base64
    List<int> imageBytes = await _image!.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(adddoctor),
    );

    request.fields['user_id'] = _userIdController.text;
    request.fields['Name'] = _nameController.text;
    request.fields['email_id'] = _emailController.text;
    request.fields['phone_no'] = _phoneController.text;
    request.fields['password'] = _passwordController.text;
    request.fields['designation'] = _designationController.text;
    request.fields['institution'] = _institutionController.text;
    request.fields['Age'] = _ageController.text;
    request.fields['Gender'] = _genderController.text;

    // Add base64 encoded image to form data
    request.fields['doctorimage'] = base64Image;

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var data = jsonDecode(responseData);
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User registration successful.')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Error occurred.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to connect to server.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
          'Add Doctor',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _getImage,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: _image != null
                      ? Image.file(
                    _image!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                      : Icon(
                    Icons.person_add_alt_1_rounded,
                    size: 80,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'User id                :',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          controller: _userIdController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Password           :',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Name                  :',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Email                   :',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Age                     :   ',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 199,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          controller: _ageController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                          'Gender                :',
                          style: TextStyle(fontSize: 20),
                        ),
                      SizedBox(width: 20),
                      Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                          onChanged: (String? value) {
                            _genderController.text = value ?? '';
                            print('Selected gender: $value');
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Others',
                              child: Text('Others'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Phone no            :',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Institution           :',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          controller: _institutionController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Designation        :',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          controller: _designationController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
                onTap: _submitForm,
                child: Text(
                  'Save',
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
