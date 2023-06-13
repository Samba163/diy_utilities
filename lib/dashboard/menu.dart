import 'package:flutter/material.dart';
import '../functions/navigate.dart';
import 'organization.dart';

class MenuPage extends StatefulWidget {
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Navigation nav = Navigation();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            // Handle option 1
            Navigator.pop(context); // Close the drawer
            nav.pushAndReplace(
              context,
              const OrganizationPage(),
            );
          },
          child: ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Organization'),
          ),
        ),
        InkWell(
          onTap: () {
            // Handle option 2
            Navigator.pop(context); // Close the drawer
          },
          child: ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Statistics'),
          ),
        ),
      ],
    );
  }
}
