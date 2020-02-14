import 'package:GoTikTokker/screens/feedscreen.dart';
import 'package:GoTikTokker/screens/userscreen.dart';
import 'package:GoTikTokker/screens/newscreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabsScreen extends StatefulWidget {
  static const routename = "/tabsscreen";
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (_index) {
      case 0:
        child = FeedScreen();
        break;
      case 1:
        child = NewScreen();
        break;
      case 2:
        child = UserScreen();
        break;
    }
    return Scaffold(
      body: SizedBox.expand(child: child),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (newIndex){
          setState(() {
            _index = newIndex;
          });
        },
        currentIndex: _index,
        backgroundColor: Colors.black,
        //type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.play, color: (_index==0) ? Colors.pink :  Colors.white),
            title: Text("Feed", style:TextStyle(color: Colors.white)),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.plus, color: (_index==1) ? Colors.pink :  Colors.white ),
            title: Text("New", style:TextStyle(color: Colors.white)),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user, color: (_index==2) ? Colors.pink :  Colors.white ),
            title: Text("User", style:TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
