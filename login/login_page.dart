import 'package:flutter/material.dart';
import '../Utils.dart';
import '../services/authentication.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage>  createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Authentication _auth = Authentication();

  Future<void> checkIfLogged() async {
    await _auth.init();
    if(_auth.userid!= null){
      handleLoginResult("success");
    }

  }

  @override
  Widget build(BuildContext context) {
    checkIfLogged();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await _auth.init();
                dynamic result = await _auth.logInUser(
                  email: _usernameController.text,
                  password: _passwordController.text,
                );
                handleLoginResult(result);
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  void handleLoginResult(dynamic result) {
    /*
    var aux = FileEditor(
      name: "page1.ml",
      language: "ocaml",
      code: "let () = print_string \"Hello world\"",
    );
    var test = DatabaseService(uid: 'ZX9wM4XZrXbKJxugXA6Er1tXswj2');
    test.uploadFile(aux);
    */

    if (result == 'success') {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      newDialog(context, result, "Attention");
    }
  }
}


/*
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils.dart';
import '../home/home.dart';
import '../services/authentication.dart';
import '../Utils.dart';



class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Authentication _auth = Authentication();


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {


                  dynamic result = await _auth.logInUser(
                      email: _usernameController.text,
                      password: _passwordController.text);
                  if(result == 'success'){
                    Navigator.pushNamed(context, "/home");
                  }else {
                    newDialog(context, result, "Attention");
                  }


              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
 */