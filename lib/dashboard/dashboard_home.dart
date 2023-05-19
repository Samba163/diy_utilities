import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:diy_utilities/dashboard/organization.dart';
import 'package:diy_utilities/dashboard/profile.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../functions/navigate.dart';
import '../providers/user_data_provider.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({Key? key}) : super(key: key);

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  Navigation nav = Navigation();
  String? selectedImagePath;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  bool _isFlashOn = false;
  // bool _isScanning = false;

  // void _openProfilePage() async {
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => ProfilePage()),
  //   );

  //   if (result != null && result is String) {
  //     setState(() {
  //       selectedImagePath = result;
  //     });
  //   }
  // }
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
      _controller?.toggleFlash();
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      launchURL(scanData.code ?? "No data available");
      _controller?.pauseCamera();
    });
  }

  Future<void> launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to open URL.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _controller?.resumeCamera();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentUserData = context.watch<UserDataProvider>().loggedInUserData;

    return Scaffold(
      endDrawer: ProfilePage(),
      endDrawerEnableOpenDragGesture: true,
      extendBody: true,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
              color: Colors.black,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            color: Colors.black,
            onPressed: () {
              nav.pushAndReplace(context, ProfilePage());
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: CachedNetworkImageProvider(
                            currentUserData == null
                                ? ''
                                : currentUserData['image'] ?? ''),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUserData == null
                                ? ''
                                : currentUserData['passionID'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            currentUserData == null
                                ? ''
                                : currentUserData['name'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.business, color: Colors.black),
              title: const Text(
                'Organization',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                nav.pushAndReplace(
                  context,
                  const OrganizationPage(),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_chart, color: Colors.black),
              title: const Text(
                'Statistics',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.blue,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
            cameraFacing: CameraFacing.back,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 10,
            child: IconButton(
              onPressed: () {
                nav.pushAndReplace(context, const MyDashboard());
              },
              icon: const Icon(Icons.refresh),
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 16,
            right: 10,
            child: IconButton(
              onPressed: _toggleFlash,
              icon: Icon(
                _isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 10,
            right: 10,
            child: SizedBox(
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const Card(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: SingleChildScrollView(
                      child: Text(
                        'Welcome to the QR Code Scanner!\n\n'
                        'Scan a QR code to perform various actions and access information quickly and conveniently.\n\n'
                        'This app uses the device\'s camera to scan QR codes. Simply point your camera at a QR code, '
                        'and the app will automatically detect and process it.\n\n'
                        'The scanned QR code can trigger different actions, such as opening a website, '
                        'displaying contact information, or providing instructions.\n\n'
                        'Use this powerful tool to unlock the potential of QR codes in your daily life!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
