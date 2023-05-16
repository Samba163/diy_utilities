import 'package:diy_utilities/constants/constants.dart';
import 'package:diy_utilities/functions/navigate.dart';
import 'package:diy_utilities/pages/authentication/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReadData {
  Navigation nav = Navigation();

  getUserData(context, UID) async {
    debugPrint("notgetUserData: $UID");
    await db.collection("users").doc(UID).get().then((value) {
      if (value.exists) {
        debugPrint("getUserData:${value.data().toString()}");
        userData = value.data()!;
      } else {
        debugPrint("notgetUserData:");

        FirebaseAuth.instance.signOut().whenComplete(() {
          nav.pushAndReplace(context, const LoginPage());
        });
      }
    });
  }
}
