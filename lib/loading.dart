import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'constants/constants.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 5), () {
      globalUID = FirebaseAuth.instance.currentUser!.uid;

      if (globalUID.toString() != "null" || globalUID.length > 5) {
        Navigator.pushReplacementNamed(context, 'dashboard_home');
      } else {
        Navigator.pushReplacementNamed(context, 'login');
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.jpg', height: 180, width: 180),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text('Loading...', style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
