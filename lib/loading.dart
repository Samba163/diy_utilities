import 'dart:async';
import 'package:diy_utilities/dashboard/dashboard_home.dart';
import 'package:diy_utilities/pages/authentication/login.dart';
import 'package:diy_utilities/providers/user_data_provider.dart';
import 'package:diy_utilities/services/read_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart';
import 'functions/navigate.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  ReadData readData = ReadData();
  Navigation nav = Navigation();

  @override
  void initState() {
    // FirebaseAuth.instance.signOut();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 5), () {
        globalUID = FirebaseAuth.instance.currentUser == null
            ? ''
            : FirebaseAuth.instance.currentUser!.uid;
        nav.pushAndReplace(context, const LoginPage());

        if (globalUID.isNotEmpty || globalUID.length > 5) {
          // readData.
          getUserData(context, globalUID);
          Provider.of<UserDataProvider>(context, listen: false).getUserData();
          nav.pushAndReplace(context, const MyDashboard());
        } else {
          //Navigator.pushReplacementNamed(context, 'login');
          nav.pushAndReplace(context, const LoginPage());
          debugPrint("step3:");
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getUserData(context, UID) async {
    debugPrint("notgetUserData: $UID");
    try {
      var data = await db.collection("users").doc(UID).get();
      if (data.exists) {
        debugPrint("getUserData 1:${data.data().toString()}");
        // if (mounted) {
        //   setState(() {
        userData = data.data()!;
        debugPrint("getUserData2: ${userData.toString()}");
        //   });
        // }
      } else {
        FirebaseAuth.instance.signOut().whenComplete(() {
          nav.pushAndReplace(context, const LoginPage());
        });
      }
    } catch (e) {
      debugPrint("notgetUserData: error  $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logoA.png', height: 180, width: 180),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text('Loading...', style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
