import 'package:flutter/material.dart';
import '../Manager.dart';
import '../Utils.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _newUsernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

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
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: ( )async {
                String result = await Manager.newUserManager(email: _newUsernameController.text, password: _newPasswordController.text);
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
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      newDialog(context, result, "Attention");
    }
  }
}
