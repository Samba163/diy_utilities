import 'package:diy_utilities/functions/navigate.dart';
import 'package:diy_utilities/pages/authentication/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController bioController = TextEditingController();
  DateTime? selectedDate;
  ImagePicker picker = ImagePicker();
  XFile? selectedImage;

  Navigation nav = Navigation();

  @override
  void dispose() {
    bioController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = pickedFile;
    });
  }

  void _saveProfileDetails() {
    String bio = bioController.text;
    String dob = _formatDate(selectedDate);

    // Process and save the user's profile details
    // ...

    // For demonstration, let's print the entered details
    print('Bio: $bio');
    print('Date of Birth: $dob');
    if (selectedImage != null) {
      print('Selected Image: ${selectedImage!.path}');
    }
  }

  void _removeImage() {
    setState(() {
      selectedImage = null;
    });
  }

  void _logout() {
    // Perform logout logic
    // ...

    // Navigate to the login page
    Navigator.pushReplacementNamed(context, 'login');
    FirebaseAuth.instance.signOut().whenComplete(() {
      nav.pushAndReplace(context, const LoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Profile Page'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _logout(),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: selectedImage != null
                            ? FileImage(File(selectedImage!.path))
                            : AssetImage('assets/images/default.jpg')
                                as ImageProvider<Object>?,
                      ),
                      if (selectedImage != null)
                        Positioned(
                          left: -15,
                          bottom: 0,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: _removeImage,
                            color: Colors.red,
                          ),
                        ),
                      Positioned(
                        right: -10,
                        bottom: 0,
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: _pickImageFromGallery,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Passion ID',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: bioController,
                    decoration: InputDecoration(
                      hintText: 'Enter your Passion ID',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Designation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: bioController,
                    decoration: InputDecoration(
                      hintText: 'Enter your Designation',
                    ),
                  ),
                  SizedBox(height: 16),
                  const Text(
                    'Date of Birth',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        hintText: 'Select your date of birth',
                      ),
                      child: Text(
                        _formatDate(selectedDate),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveProfileDetails,
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
