import 'dart:async';
import 'package:diy_utilities/phone.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:diy_utilities/home.dart';

import 'otp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: 'loading',
    routes: {
      'loading': (context) => LoadingPage(),
      'phone': (context) => MyPhone(),
      'otp': (context) => MyOtp(),
      'home': (context) => MyHome(),
    },
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DIY_Utility',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoadingPage(),
    );
  }
}

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, 'phone');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.jpg', height: 180, width: 180),
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading...', style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
