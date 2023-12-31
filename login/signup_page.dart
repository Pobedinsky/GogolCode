import 'package:flutter/material.dart';

import '../Utils.dart';
import '../services/authentication.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _newUsernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  final Authentication _auth = Authentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _newUsernameController,
              decoration: const InputDecoration(labelText: 'New Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: ( )async {
                await _auth.init();
            dynamic result = await _auth.newUser(email: _newUsernameController.text, password: _newPasswordController.text);
            if(result == 'success'){
              Navigator.pushNamed(context, "/home");
            }
            else {
              newDialog(context, result, "Attention");
            }
            },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import '../services/authentication.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _newUsernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final Authentication _auth = Authentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _newUsernameController,
              decoration: const InputDecoration(labelText: 'New Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                dynamic result = await _auth.newUser(
                  email: _newUsernameController.text,
                  password: _newPasswordController.text,
                );
                handleRegistrationResult(result);
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  void handleRegistrationResult(dynamic result) {
    if (result == 'success') {
      Navigator.pushNamed(context, "/home");
    } else {
      newDialog(context, result, "Attention");
    }
  }
}

 */