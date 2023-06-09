import 'package:diy_utilities/providers/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../constants/constants.dart';
import '../../dashboard/dashboard_home.dart';

import 'login.dart';

class MyOtp extends StatefulWidget {
  final ValueChanged onPressed;

  const MyOtp({ Key? key, required this.onPressed}) : super(key: key);

  @override
  State<MyOtp> createState() => _MyOtpState();
}

class _MyOtpState extends State<MyOtp> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Timer? _timer;
  int _countDown = 30;
  bool _isResendEnabled = false;
  bool _showInvalidOtpError = false;
  int? resendingToken;

  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_countDown == 0) {
          setState(() {
            _isResendEnabled = true;
            timer.cancel();
          });
        } else {
          setState(() {
            _countDown--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void sendOTP() async {
    // Replace this with your actual OTP sending logic
    print('Sending OTP...');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          resendingToken = resendToken;
          LoginPage.verify = verificationId;
        });

        // Navigator.pushNamed(context, "otp");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      forceResendingToken: resendingToken,
      timeout: const Duration(seconds: 60),
    );
  }

  void resendOTP() {
    sendOTP();
    setState(() {
      _countDown = 30;
      _isResendEnabled = false;
      startTimer();
    });
  }

  void goBack() {
    // Perform any necessary tasks before going back
    // Call the updatePageChanged callback function
    // LoginPage loginPage =
    //     ModalRoute.of(context)!.settings.arguments as LoginPage;
    // loginPage.updatePageChanged(false);
    // widget.onPressed(false);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    // ignore: unused_local_variable
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    String code = "";
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => goBack(),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logoA.png', // Replace with your actual logo image file
                width: 100,
                height: 100,
                // Adjust the width and height according to your needs
              ),
              const SizedBox(height: 40),
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Pinput(
                length: 6,
                showCursor: true,
                onChanged: (value) {
                  setState(() {
                    code = value;
                    _showInvalidOtpError = false;
                  });
                },
                controller: _otpController,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton(
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
                ],
              ),
              SizedBox(
                height: 50,
                width: 120,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      debugPrint(
                          'the code is $code and controller text is ${_otpController.text.trim()}');
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                        verificationId: LoginPage.verify,
                        smsCode: _otpController.text.trim(),
                      );

                      // Sign the user in (or link) with the credential
                      await auth.signInWithCredential(credential);

                      setState(() {
                        globalUID = FirebaseAuth.instance.currentUser == null
                            ? ''
                            : FirebaseAuth.instance.currentUser!.uid;
                      });

                      // ignore: use_build_context_synchronously
                      Provider.of<UserDataProvider>(context, listen: false)
                          .getUserData();

                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyDashboard()),
                        (route) => false,
                      );
                    } catch (e) {
                      debugPrint('error $e');
                      setState(() {
                        _showInvalidOtpError = true; // Show the error message
                      });
                      print("wrong otp");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Verify OTP',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible:
                    _showInvalidOtpError, // Show the error message if the OTP is invalid
                child: const Text(
                  'Invalid OTP',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Did't Recive the OTP?\nRetry in $_countDown seconds",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                  SizedBox(
                    height: 40,
                    width: 110,
                    child: ElevatedButton(
                      onPressed: _isResendEnabled ? resendOTP : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
