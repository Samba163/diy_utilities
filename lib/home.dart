import 'package:flutter/material.dart';

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              "Dashboard",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.menu),
              color: Colors.black,
              onPressed: () {
                // Implement menu functionality
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "phone");
                },
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Image.asset(
                'assets/images/logo.jpg',
                height: 100,
                width: 100,
              ),
              SizedBox(height: 60),
              Image.asset(
                'assets/images/login.png',
                width: 100,
                height: 100,
              ),
            ],
          ),
          SizedBox(height: 30),
          Text(
            "Logged in Successfully",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decoration: TextDecoration.none),
          ),
        ],
      ),
    );
  }
}
