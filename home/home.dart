import 'package:code_editor/code_editor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_2_files/services/database.dart';
import '../Utils.dart';
import '../services/authentication.dart';


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programming Languages Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle logout logic here
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: LanguageMenu(),
    );
  }

  // Function to show a logout confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Perform the actual logout logic here
                // For example, clear user preferences, navigate to login screen, etc.
                // ...
                var aux = Authentication();
                await aux.init();
                    aux.signOut(context);

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}

class LanguageMenu extends StatefulWidget {
  @override
  _LanguageMenuState createState() => _LanguageMenuState();
}

class _LanguageMenuState extends State<LanguageMenu> {
  late SharedPreferences prefs;
  List<String> entries = <String>['Ocaml', 'Java', 'C', 'Python'];
  List<int> colorCodes = <int>[600, 500, 100, 0];

  Future<void> loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    loadPreferences();
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          color: Colors.amber[colorCodes[index]],
          child: TextButton(
            onPressed: () async {
              showLoaderDialog(context);
              var token = prefs.getString('user_token')??"";
              var a = DatabaseService(uid: token);

              var language = entries[index].toLowerCase();

              var idWithFile = await a.getFiles(language);
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pushNamed(context, "/files", arguments: {'files': idWithFile, 'prefs' : prefs, 'language' : language});
            },
            child: Center(child: Text(entries[index])),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
      const Divider(color: Colors.white),
    );
  }
}

