import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diy_utilities/constants/constants.dart';
import 'package:diy_utilities/functions/navigate.dart';
import 'package:diy_utilities/pages/authentication/login.dart';
import 'package:diy_utilities/providers/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController bioController;
  late TextEditingController idController;
  late TextEditingController DoBController;
  String designation = "";
  String passionId = "";
  String dob = "";
  DateTime? selectedDate;
  ImagePicker picker = ImagePicker();
  XFile? selectedImage;
  String imageUrl = '';
  String? localImagePath;

  Navigation nav = Navigation();

  @override
  void dispose() {
    bioController.dispose();
    idController.dispose();
    DoBController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var currentUserData =
        Provider.of<UserDataProvider>(context, listen: false).loggedInUserData;
    bioController = TextEditingController(text: currentUserData['designation']);
    idController = TextEditingController(text: currentUserData['passionID']);
    DoBController = TextEditingController(
        text: _formatDate(currentUserData['dateOfBirth'].toDate()).toString());

    designation = currentUserData['designation'];
    passionId = currentUserData['passionID'];
    dob = _formatDate(currentUserData['dateOfBirth'].toDate()).toString();

    // fetchImageUrl();
  }

  Future<void> fetchImageUrl() async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('users');
    Reference referenceUID = referenceDirImages.child(globalUID);
    Reference referenceImage = referenceUID.child('profile_image.jpg');
    try {
      imageUrl = await referenceImage.getDownloadURL();
      setState(() {
        imageUrl = imageUrl;
      });
    } catch (error) {
      print('Error fetching image URL: $error');
    }
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
        DoBController.text = _formatDate(selectedDate).toString();
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      selectedImage = pickedFile;
    });
    Directory tempDir = await getTemporaryDirectory();
    String imagePath = path.join(tempDir.path, 'selected_image.jpg');

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('users');
    Reference referenceUID = referenceDirImages.child(globalUID);
    Reference referenceImageToUpload = referenceUID.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(pickedFile.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(globalUID).set({
        'image': imageUrl,
      }, SetOptions(merge: true));

      print('Image URL: $imageUrl');

      // Save the image locally
      Directory appDir = await getApplicationDocumentsDirectory();
      String localImagePath = '${appDir.path}/profile_image.jpg';
      File localImageFile = File(localImagePath);
      await localImageFile.writeAsBytes(await pickedFile.readAsBytes());
      setState(() {
        this.localImagePath = localImagePath;
      });
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  Future<void> _saveProfileDetails(currentUserData) async {
    String bio = bioController.text;
    String dob = _formatDate(selectedDate);

    // Process and save the user's profile details
    // ...

    Map<String, dynamic> dataToBeUpdated = {};

    if (designation != bioController.text.trim()) {
      dataToBeUpdated['designation'] = bioController.text.trim();
    }
    // if (dob != _formatDate(selectedDate).toString()) {
    if (currentUserData['dateOfBirth'] != selectedDate) {
      dataToBeUpdated['dateOfBirth'] = selectedDate;
    }
    if (passionId != idController.text.trim()) {
      dataToBeUpdated['passionID'] = idController.text.trim();
    }
    debugPrint('data map $dataToBeUpdated');

    await FirebaseFirestore.instance
        .collection('users')
        .doc(globalUID)
        .set(dataToBeUpdated, SetOptions(merge: true));

    // For demonstration, let's print the entered details
    print('Bio: $bio');
    print('Date of Birth: $dob');
    if (selectedImage != null) {
      print('Selected Image: ${selectedImage!.path}');
    }
  }

  void _removeImage() async {
    await FirebaseFirestore.instance.collection('users').doc(globalUID).set({
      'image': '',
    }, SetOptions(merge: true));

    setState(() {
      selectedImage = null;
      localImagePath = null;
    });
  }

  void _logout() {
    // Perform logout logic
    // ...

    // Navigate to the login page
    Navigator.pushReplacementNamed(context, 'login');
    FirebaseAuth.instance.signOut().whenComplete(() {
      Provider.of<UserDataProvider>(context, listen: false).cancel;
      nav.pushAndReplace(context, const LoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentUserData = context.watch<UserDataProvider>().loggedInUserData;

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
                        backgroundImage: currentUserData['image'].isNotEmpty
                            ? NetworkImage(currentUserData['image'])
                            : AssetImage('assets/images/default.jpg')
                                as ImageProvider<Object>?,
                      ),
                      Positioned(
                        left: -15,
                        bottom: 0,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed:
                              currentUserData['image'].toString().isNotEmpty
                                  ? _removeImage
                                  : null,
                          color: currentUserData['image'].toString().isNotEmpty
                              ? Colors.red
                              : Colors.grey,
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
                    controller: idController,
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
                    child: TextField(
                      onTap: () => _selectDate(context),
                      controller: DoBController,
                      decoration: InputDecoration(
                        hintText: 'Select your date of birth',
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _saveProfileDetails(currentUserData),
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
