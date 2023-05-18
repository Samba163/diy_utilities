import 'package:diy_utilities/loading.dart';
import 'package:diy_utilities/pages/authentication/login.dart';
import 'package:diy_utilities/pages/authentication/otp.dart';
import 'package:diy_utilities/providers/user_data_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard/dashboard_home.dart';
import 'dashboard/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => UserDataProvider(),
      )
    ],
    child: MaterialApp(
      initialRoute: 'loading',
      routes: {
        'loading': (context) => const LoadingPage(),
        'login': (context) => const LoginPage(),
        'otp': (context) => MyOtp(
              onPressed: (value) {},
            ),
        'dashboard_home': (context) => const MyDashboard(),
        'profile': (context) => ProfilePage(),
      },
    ),
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
      home: const LoadingPage(),
    );
  }
}
