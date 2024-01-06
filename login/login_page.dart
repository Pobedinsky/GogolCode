import 'package:flutter/material.dart';
import '../Manager.dart';
import '../Utils.dart';

class LoginPage extends StatefulWidget {

  @override
  State<LoginPage>  createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (Manager.auth.userid != null) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, "/home");
      });
    }
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
              decoration: const InputDecoration(labelText: 'Email'),
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
                dynamic result = await Manager.logInManager(
                  email: _usernameController.text,
                  password: _passwordController.text,
                );
                handleLoginResult(result);
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () { Navigator.pushNamed(context, '/register'); },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  void handleLoginResult(dynamic result) {
    if (result == 'success') {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      newDialog(context, result, "Attention");
    }
  }
}
