import 'package:flutter/material.dart';
import 'package:flutter_do/util/auth_n.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  onPressed: () => gSignin(),
                  child: Text('Sign in with Google'),
              )
            ),
          ],
        ),
      ),
    );
  }
}
