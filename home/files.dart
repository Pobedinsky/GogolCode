import 'package:code_editor/code_editor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_2_files/services/database.dart';

class FileList extends StatefulWidget {
  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  late dynamic arguments;
  late List<Map<String, FileEditor>> entries;
  late SharedPreferences prefs;
  late String language;
  final TextEditingController _newFileNameController = TextEditingController();

  Future<void> load_data() async {
    arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    entries = arguments['files'];
    prefs = arguments['prefs'];
    language = arguments['language'];
  }

  @override
  Widget build(BuildContext context) {
    load_data();

    return Scaffold(
      appBar: AppBar(title: const Text("Current Files")),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 50,
                  child: TextButton(
                    onLongPress: () {
                      _showDeleteConfirmationDialog(entries[index], prefs);
                    },
                    onPressed: () {
                      Navigator.pushNamed(context, "/CodeBox", arguments: {'file': entries[index]});
                    },
                    child: Center(child: Text(entries[index].values.first.name)),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _showNewFileDialog(); // Show the new file dialog
              },
              child: const Text("New File"),
            ),
          ),
        ],
      ),
    );
  }

  // Function to show a delete confirmation dialog
  void _showDeleteConfirmationDialog(Map fileEntry, SharedPreferences prefs) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete File"),
          content: Text("Are you sure you want to delete ${fileEntry.values.first.name}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Perform the actual deletion logic here
                // For now, let's just print a message
                var uid = prefs.getString('user_token') ?? "";
                DatabaseService a = DatabaseService(uid: uid);
                a.deleteFileEditor(fileEntry.values.first, fileEntry.keys.first);
                print("File ${fileEntry.values.first.name} deleted");

                setState(() {
                  entries.remove(fileEntry);
                });

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // Function to show a dialog for creating a new file
  void _showNewFileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("New File"),
          content: Column(
            children: [
              TextField(
                controller: _newFileNameController,
                decoration: const InputDecoration(labelText: "File Name"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Perform the logic for creating a new file here
                // You can use the _newFileNameController.text to get the entered file name
                String newFileName = _newFileNameController.text.trim();

                var uid = prefs.getString('user_token') ?? "";
                DatabaseService a = DatabaseService(uid: uid);
                FileEditor tmp = FileEditor(name: newFileName, language: language, code: "");
                String f_id = await a.uploadFile(tmp);

                // For now, let's just print a message
                print("New file created: $newFileName");


                setState(() {
                  entries.add({f_id : tmp});
                });

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }
}


