import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  static const routename = "/tabsscreen";
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.pink,
      ),
    );
  }
}
