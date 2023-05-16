import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController bioController = TextEditingController();
  DateTime? selectedDate;
  ImagePicker picker = ImagePicker();
  XFile? selectedImage;

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

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Profile Page'),
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
                            : const AssetImage('assets/images/default.jpg')
                                as ImageProvider<Object>?,
                      ),
                      if (selectedImage != null)
                        Positioned(
                          left: -15,
                          bottom: 0,
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: _removeImage,
                            color: Colors.red,
                          ),
                        ),
                      Positioned(
                        right: -10,
                        bottom: 0,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: _pickImageFromGallery,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Bio',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: bioController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your bio',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Date of Birth',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        hintText: 'Select your date of birth',
                      ),
                      child: Text(
                        _formatDate(selectedDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveProfileDetails,
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('back'),
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
