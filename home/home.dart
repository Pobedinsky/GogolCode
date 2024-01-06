import 'package:flutter/material.dart';
import '../Manager.dart';
import '../Utils.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programming Languages Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () { _showLogoutConfirmationDialog(context); },
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
              onPressed: () { Navigator.of(context).pop(); }, //close dialog
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Manager.signOutManager(context);
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
  const LanguageMenu({super.key});

  @override
  _LanguageMenuState createState() => _LanguageMenuState();
}

class _LanguageMenuState extends State<LanguageMenu> {
  List<String> entries = <String>['Ocaml', 'Java', 'C', 'Python'];

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      padding: const EdgeInsets.all(8),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return TextButton(
            onPressed: () async {
              showLoaderDialog(context);
              var language = entries[index].toLowerCase();
              var idWithFile = await Manager.getFilesManager(language);
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pushNamed(context, "/files", arguments: {'files': idWithFile, 'language' : language});
            }, child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image:  DecorationImage(
              image: Manager.appImages[entries[index]]!,
              fit: BoxFit.cover,
            ),
            border: Border.all(
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          width: double.infinity, // Set the width to take the full width of the screen
          height: 120,),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.white),
    );
  }
}
