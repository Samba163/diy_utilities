import 'package:diy_utilities/constants/constants.dart';
import 'package:diy_utilities/dashboard/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../functions/navigate.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({super.key});

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  Navigation nav = Navigation();

  Future<void> scanBarcode(BuildContext context) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scan button
      'Cancel', // Text for the cancel button
      false, // Whether to show the flash icon on the scan screen
      ScanMode.DEFAULT, // Scan mode (default, QR code, barcode)
    );

    if (barcodeScanRes != '-1') {
      print('Scanned Data: $barcodeScanRes');
      // ignore: use_build_context_synchronously
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
              //Navigator.pushReplacementNamed(context, 'profile');

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
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Option 1'),
              onTap: () {
                // Handle option 1
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Option 2'),
              onTap: () {
                // Handle option 2
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
