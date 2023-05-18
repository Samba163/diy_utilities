import 'package:cached_network_image/cached_network_image.dart';

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

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
      // _isScanning = true;
    });
    controller.scannedDataStream.listen((scanData) {
      // if (_isScanning) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Scanned Data'),
            content: Text(scanData.code ?? 'No data available'),
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
      _controller?.pauseCamera();
      // setState(() {
      //   _isScanning = false;
      // });
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentUserData = context.watch<UserDataProvider>().loggedInUserData;

    return Scaffold(
      endDrawer: ProfilePage(),
      endDrawerEnableOpenDragGesture: true,
      extendBody: true,
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
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
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(
                        color: Colors.white,
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
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            currentUserData == null
                                ? ''
                                :
                            currentUserData['name'],
                            style: const TextStyle(
                                color: Colors.white,
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
              title: const Text('Organization'),
              onTap: () {
                nav.pushAndReplace(
                  context,
                  const OrganizationPage(),
                );
              },
            ),
            ListTile(
              title: const Text('Statistics'),
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
        ],
      ),
    );
  }
}
