import 'package:GoTikTokker/providers/authprovider.dart';
import 'package:GoTikTokker/screens/tabsscreen.dart';
import 'package:GoTikTokker/services/concheck.dart';
import 'package:GoTikTokker/services/custominfodialog.dart';
import 'package:GoTikTokker/services/erroormsgmaker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routename = "/loginscreen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  bool _isLoading = false;
  String _loadingMsg = "";
  bool authStatus = true;

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _submitForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    // Connectivity Checking
    bool conCheck = await ConCheck.checkData();
    if (!conCheck) {
      return;
    }
    setState(() {
      _loadingMsg = "🔑Checking Your Credentials🔐\nPlease Wait ...";
      _isLoading = true;
    });
    await Provider.of<AuthProvider>(context, listen: false)
        .loginWithEmail(email: _email, password: _password)
        .catchError((er) {
      print(er);
      authStatus = false;
      String emsg = ErrorMsgMaker.msgMaker(error: er.toString());
      CustomInfoDialog.showInfoDialog(
          ctx: context, title: "Authentication Failed", message: emsg);
      return;
    });
    if(authStatus){
      Navigator.of(context).pushNamed(TabsScreen.routename);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Text(_loadingMsg, textAlign: TextAlign.center),
              ],
            ))
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.2,
                    left: 20,
                    right: 20,
                    bottom: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "GoTikTokker",
                          style: TextStyle(
                              fontSize: 40,
                              decoration: TextDecoration.underline,
                              //decorationStyle: TextDecorationStyle.wavy,
                              decorationColor: Colors.pink),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Login',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (evalue) {
                          _email = evalue;
                        },
                        validator: (value) {
                          if (value.isEmpty || !value.contains("@")) {
                            return "Invalid Email";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: "Password",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        keyboardType: TextInputType.text,
                        onSaved: (pvalue) {
                          _password = pvalue;
                        },
                        validator: (value) {
                          if (value.isEmpty || !(value.length > 6)) {
                            return "Invalid Password";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        width: double.infinity,
                        child: RaisedButton(
                          padding: EdgeInsets.all(10),
                          onPressed: _submitForm,
                          color: Colors.pink,
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Not have Account yet SignUp Now",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
