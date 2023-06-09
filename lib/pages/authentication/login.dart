import 'package:diy_utilities/constants/constants.dart';
import 'package:diy_utilities/pages/authentication/otp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController countrycode = TextEditingController();
  var phone = "";
  bool isButtonEnabled = false;
  bool isLoading = false;
  // bool isPageChanged = true;

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

  void startLoading() {
    setState(() {
      isLoading = true;
      // isPageChanged = false;
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
        // isPageChanged = true;
      });
    });
  }

  void updatePageChanged(bool value) {
    setState(() {
      // isPageChanged = value;
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pushNamed(context, "phone");
          },
        ),
        title: const Text(
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
          Image.asset('assets/images/logoA.png', height: 100, width: 100),
          const SizedBox(height: 70),
          const Text(
            'Phone Verification',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                SizedBox(
                  width: 40,
                  child: TextField(
                    controller: countrycode,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
                const Text(
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
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "login",
                  (route) => false,
                );
              },
              child: const Text(
                'Edit phone number',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            width: 120,
            child: ElevatedButton(
              onPressed: isButtonEnabled && !isLoading
                  ? () async {
                      setState(() {
                        isLoading = true;
                        phoneNumber = countrycode.text + phone;
                        // isPageChanged = false;
                      });
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: '${countrycode.text + phone}',
                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          LoginPage.verify = verificationId;
                          // Navigator.pushNamed(context, "otp");
                          updatePageChanged(false);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MyOtp(
                                onPressed: ((value) => updatePageChanged));
                          }));
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                        // timeout: const Duration(seconds: 60),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                // ignore: deprecated_member_use
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isLoading ? 'Loading...' : 'Get OTP',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
