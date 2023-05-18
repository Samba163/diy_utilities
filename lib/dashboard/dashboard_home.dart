import 'package:cached_network_image/cached_network_image.dart';
import 'package:diy_utilities/constants/constants.dart';
import 'package:diy_utilities/dashboard/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../functions/navigate.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({Key? key}) : super(key: key);

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  Navigation nav = Navigation();
  String? selectedImagePath;
  String? userProfilePicUrl =
      'https://firebasestorage.googleapis.com/v0/b/diy-project-c9df6.appspot.com/o/users%2FVzNQTV639NO4361w2ahtRp4RpQW2%2F1684391068420?alt=media&token=b7ed60c2-1b33-4686-9fea-1f48b032c87d'; // Replace with the actual URL of the profile picture

  Future<void> scanBarcode(BuildContext context) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scan button
      'Cancel', // Text for the cancel button
      false, // Whether to show the flash icon on the scan screen
      ScanMode.DEFAULT, // Scan mode (default, QR code, barcode)
    );

    if (barcodeScanRes != '-1') {
      print('Scanned Data: $barcodeScanRes');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Scanned Data'),
            content: Text(barcodeScanRes),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      print('Scan canceled by the user');
    }
  }

  @override
  void initState() {
    debugPrint(userData.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ProfilePage(),
      endDrawerEnableOpenDragGesture: true,
      extendBody: true,
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              nav.push(context, ProfilePage());
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        CachedNetworkImageProvider(userProfilePicUrl ?? ''),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Organization'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Statistics'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: ElevatedButton(
            child: Text('Scan Barcode'),
            onPressed: () => scanBarcode(context),
          ),
        ),
      ),
    );
  }
}
