import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diy_utilities/constants/constants.dart';
import 'package:flutter/material.dart';

class UserDataProvider with ChangeNotifier {
  // ignore: prefer_typing_uninitialized_variables
  var currentUserData, userStream;
  get loggedInUserData => currentUserData;
  get cancel => userStream;

  getUserData() {
    userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(globalUID)
        .snapshots()
        .listen((user) {
      var userData = user.data();
      currentUserData = userData;
      notifyListeners();
    });
  }

  cancelStream() {
    try {
      userStream.cancel();
    } catch (e) {
      debugPrint('error while cancelling the stream $e');
    }
  }
}
