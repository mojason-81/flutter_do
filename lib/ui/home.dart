import 'package:flutter/material.dart';
import 'package:flutter_do/ui/sign_in_screen.dart';
import 'package:flutter_do/ui/todo_list.dart';
import 'package:flutter_do/util/auth_n.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // TODO: If not signed in, render sign-in widget(s).
  // TODO: If signed in, render home screen.
  // TODO: Add google sign-in support
  // TODO: Add controllers for email & password for sign-in
  bool _signedIn = false;

  @override
  Widget build(BuildContext context) {
    checkSignInState();
    if (_signedIn) {
      // debugPrint("Signed in");
      return ToDoList();
    } else {
      debugPrint("Not signed in");
      return SignInScreen();
    }
  }

  void checkSignInState() async {
    bool s = await signedIn();
    setState(() {
      // _signedIn = false;
      _signedIn = s;
    });
  }
}
