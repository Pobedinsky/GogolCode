import 'package:flutter/material.dart';
import 'package:code_editor/code_editor.dart';
import '../Manager.dart';
import '../Utils.dart';

class CodeBox extends StatelessWidget {
  const CodeBox({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    var page = arguments['file'];

    var model = EditorModel(
      files: [page.values.first],
      styleOptions: EditorModelStyleOptions(
        showUndoRedoButtons: true,
        heightOfContainer: 400,
        placeCursorAtTheEndOnEdit: true,
        reverseEditAndUndoRedoButtons: true,
      )..defineEditButtonPosition(
        bottom: 10,
        left: 15,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text("${model.allFiles[0].language}Code")),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                Manager.updateFileManager(model.allFiles[0], model.allFiles[0].code, page.keys.first);
              },
              child: const Text('  Save '),
            ),
          ],
        ),
      ),
    );
  }
}
