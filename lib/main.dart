import 'package:GoTikTokker/providers/videodatablock.dart';
import 'package:GoTikTokker/screens/loginscreen.dart';
import 'package:GoTikTokker/providers/authprovider.dart';
import 'package:GoTikTokker/screens/tabsscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProvider.value(
          value: VideoDataBlock(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.pink, primarySwatch: Colors.pink),
        home: MyHomePage(),
        routes: {
          LoginScreen.routename: (ctx) => LoginScreen(),
          TabsScreen.routename: (ctx) => TabsScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkAuthentication(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return TabsScreen();
            } else {
              return LoginScreen();
            }
          }
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  child: Image.asset("assets/logo.png", fit: BoxFit.cover),
                ),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> checkAuthentication() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }
}
