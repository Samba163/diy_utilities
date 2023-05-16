import 'package:diy_utilities/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => MyHomePage(),
        '/profile_page': (context) => ProfilePage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
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
            title: Text('Scanned Data'),
            content: Text(barcodeScanRes),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile_page');
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
