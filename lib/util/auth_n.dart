import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);

Future<FirebaseUser> gSignin() async {
  GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  FirebaseUser user = await _auth.signInWithGoogle(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);

  print("User is: ${user.email}");

  return user;
}

Future createUser() async {
  await _auth
      .createUserWithEmailAndPassword(
          email: "ramthegreaterer@gmail.com", password: "hiltongrace2345")
      .then((userNew) {
    print("User created ${userNew.displayName}");
    print("Email: ${userNew.email}");
  });
}

logout() {
  _auth.signOut();
  _googleSignIn.signOut().then((user) => print(user));
}

signInWithEmail() {
  _auth
      .signInWithEmailAndPassword(
          email: "ramthegreaterer@gmail.com", password: "hiltongrace2345")
      .catchError((error) {
    print("Something went wrong! ${error.toString()}");
  }).then((newUser) {
    print("User signed in: ${newUser.email}");
  });
}

Future<bool> signedIn() {
  // _auth.currentUser().then((user) => print(user.email));
  return _auth.currentUser().then((user) {
    if (user != null) {
      return true;
    } else {
      return false;
    }
  });
}
