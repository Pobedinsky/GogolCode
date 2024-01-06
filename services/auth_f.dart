import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  late SharedPreferences prefs;
  String? userid;

  Future<void> init(SharedPreferences prefsArg) async {
    prefs = prefsArg;
    var aux = _auth.currentUser;
    if (aux != null) {
      userid = aux.uid;
      prefs.setString('user_token', userid!);
    }
  }

  Future<String> logInUser({required String email, required String password,}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        var out = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        prefs.setString('user_token', out.user!.uid);
        return 'success';
      }
    } catch (err) { return "Wrong or empty credentials";}
    return "Fill the fields properly";
  }

  Future<String> newUser({required String email, required String password,}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        var credentials = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        prefs.setString('user_token', credentials.user!.uid);
        return 'success';
      }
    } catch (err) { return "Try with other credentials"; }
    return "Fill the fields properly";
  }

  Future signOut(BuildContext context)  async{
    await _auth.signOut();
    userid = null;
    prefs.clear();
    Navigator.pushReplacementNamed(context, '/');

  }
}
