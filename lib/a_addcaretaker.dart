import 'dart:convert';
import 'dart:io';
import 'common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddCaretaker extends StatefulWidget {
  final double borderWidth;
  final double padding;

  const AddCaretaker({Key? key, this.borderWidth = 1.0, this.padding = 10.0}) : super(key: key);

  @override
  _AddCaretakerState createState() => _AddCaretakerState();
}

class _AddCaretakerState extends State<AddCaretaker> {
  final _formKey = GlobalKey<FormState>();
  File? _image;

  final _picker = ImagePicker();
  TextEditingController _userIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _relationshipController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _patientIdController = TextEditingController();
  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _patientAgeController = TextEditingController();
  TextEditingController _patientDiagnosisController = TextEditingController();
  TextEditingController _pgenderController = TextEditingController();

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.only(left: 20),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 80,
        backgroundColor: Colors.blue[100],
        title: Text(
          'Add Caretaker',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: widget.borderWidth,
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: GestureDetector(
                    onTap: _getImage,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
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
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildRow("User id            :", _userIdController),
                    buildRow("Password       :", _passwordController),
                    buildRow("Name              :", _nameController),
                    buildRow("Age                  :", _ageController),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            'Gender            :',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            width: 220,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select gender';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    buildRow("Phone no        :", _phoneNoController),
                    SizedBox(height: 10),
                    buildRow("Relationship   :", _relationshipController),
                    SizedBox(height: 20),
                    Text(
                      'Patient Details',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    buildRow("Name              :", _patientNameController),
                    buildRow("Age                  :", _patientAgeController),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            'Gender            :',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            width: 220,
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
                                _pgenderController.text = value ?? '';
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select gender';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    buildRow("Diagnosis        :", _patientDiagnosisController),
                  ],
                ),
              ],
            ),
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
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    // Save data and navigate back
                    _saveFormData();
                  }
                },
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

  // Function to build a row with a text and a text field
  Widget buildRow(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              labelText,
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                controller: controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to save form data
  void _saveFormData() async {
    // Convert image to base64 string
    String? base64Image;
    if (_image != null) {
      List<int> imageBytes = await _image!.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    // Create a map of form data
    Map<String, dynamic> formData = {
      'user_id': _userIdController.text,
      'password': _passwordController.text,
      'Name': _nameController.text,
      'Age': _ageController.text,
      'phone_no': _phoneNoController.text,
      'gender': _genderController.text,
      'Relationship': _relationshipController.text,
      'Patient ID': _patientIdController.text,
      'p_Name': _patientNameController.text,
      'p_Age': _patientAgeController.text,
      'p_Gender': _pgenderController.text, // Use gender controller
      'Diagnosis': _patientDiagnosisController.text,
      'caretaker_image': base64Image, // Add base64 encoded image to form data
    };

    // Send a POST request to your PHP backend
    var url = (addct);
    var response = await http.post(Uri.parse(url), body: formData);

    // Handle the response here
    if (response.statusCode == 200) {
      print('Form data sent successfully');
      print(response.body);
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Caretaker successfully added'),
        ),
      );
      // Navigate back
      Navigator.of(context).pop();
    } else {
      print('Failed to send form data');
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add caretaker. Please try again later.'),
        ),
      );
    }
  }
}
