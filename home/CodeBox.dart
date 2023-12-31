
import 'package:flutter/material.dart';
import 'package:code_editor/code_editor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils.dart';
import 'package:testing_2_files/services/database.dart';


class CodeBox extends StatefulWidget {
  const CodeBox({super.key});


  @override
  State<CodeBox> createState() => _CodeBox();
}

class _CodeBox extends State<CodeBox> {
  String output = "";


  @override
  Widget build(BuildContext context) {

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    var page = arguments['file'];

    List<FileEditor> files = [page.values.first];

    var model = EditorModel(

      files: files,
      styleOptions: EditorModelStyleOptions(
        showUndoRedoButtons: true,
        heightOfContainer: 400,
        placeCursorAtTheEndOnEdit: true,
        reverseEditAndUndoRedoButtons: true,
      )..defineEditButtonPosition( // yes with 2 dots
        bottom: 10,
        left: 15,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("SamovarCraft")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*
            Container(
              decoration: BoxDecoration(
                color: Colors.orange[100],
                image: DecorationImage(
                  image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/OCaml_Logo.svg/2560px-OCaml_Logo.svg.png'),
                  fit: BoxFit.fitWidth,
                ),
                border: Border.all(
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity, // Set the width to take the full width of the screen
              height: 100, // Set the height as per your requirement
            ),*/

            CodeEditor(
                model: model,
                formatters: [model.allFiles[0].language],
              ),

            ElevatedButton(
              onPressed: () => showCodeOutput(context, model.allFiles[0].code,  model.allFiles[0].language),
              child: const Text('Run Code'),
            ),
            ElevatedButton(
              onPressed: () async {
                 SharedPreferences prefs = await SharedPreferences.getInstance();
                 var uid = prefs.getString('user_token')??"";
                 DatabaseService aux = DatabaseService(uid: uid);
                 aux.updateFile(model.allFiles[0], model.allFiles[0].code, page.keys.first);
                },
              child: const Text('  Save '),
            ),

          ],
        ),
      ),
    );
  }
}


