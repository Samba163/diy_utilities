import 'package:diy_utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countrycode = TextEditingController();
  var phone = "";
  bool isButtonEnabled = false;

  @override
  void initState() {
    countrycode.text = "+91";
    super.initState();
  }

  void checkButtonEnabled() {
    setState(() {
      isButtonEnabled = phone.length == 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pushNamed(context, "phone");
          },
        ),
        title: Text(
          "Login",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Image.asset('assets/images/logo.jpg', height: 100, width: 100),
          SizedBox(height: 70),
          Text(
            'Phone Verification',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SizedBox(width: 10),
                SizedBox(
                  width: 40,
                  child: TextField(
                    controller: countrycode,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                Text(
                  "|",
                  style: TextStyle(fontSize: 33, color: Colors.grey),
                ),
                Expanded(
                  child: TextField(
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      phone = value;
                      checkButtonEnabled();
                    },
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter phone number",
                      counterText: "",
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 50,
            width: 120,
            child: ElevatedButton(
              onPressed: isButtonEnabled
                  ? () async {
                      setState(() {
                        phoneNumber = countrycode.text + phone;
                      });
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: '${countrycode.text + phone}',
                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          MyPhone.verify = verificationId;
                          Navigator.pushNamed(context, "otp");
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                        // timeout: const Duration(seconds: 60),
                      );
                    }
                  : null,
              child: Text(
                'Get OTP',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
