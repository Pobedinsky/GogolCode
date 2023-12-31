import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<String> runCode(String code, String language) async {
  const String url =
      'https://acclaimedabandonedinstitute--maksimpobedinsky.repl.co/runcode';

  try {
    http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'code': code, 'language': language.toLowerCase()}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (kDebugMode) {
        print("200");
      }
      return data['result'];
    } else {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (kDebugMode) {
        print("CODE 200: ${response.reasonPhrase}");
      }
      return data['result'];
    }
  } catch (error) {
    if (kDebugMode) {
      print("erro");
    }
    return 'Bad Connection';
  }
}

Future<void> showCodeOutput(
    BuildContext context, String code, String language) async {
  showLoaderDialog(context);
  final result = await runCode(code, language);
  Navigator.of(context, rootNavigator: true).pop();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Output:'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(result),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: const EdgeInsets.only(left: 7),
            child: const Text("Loading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showLoadingPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible:
        false, // Set to true if you want to allow dismissing by tapping outside the popup
    builder: (BuildContext context) {
      return const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitCircle(
              color: Colors.blue, // Customize the color of the loading spinner
              size: 50.0, // Customize the size of the loading spinner
            ),
            SizedBox(height: 16.0),
            Text("Loading..."),
          ],
        ),
      );
    },
  );
}

T popupLoadFunc<T>(BuildContext context, Function a) {
  showLoadingPopup(context);
  var aux = a();
  Navigator.of(context).pop();
  return aux;
}

void newDialog(BuildContext context, String text, String title) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(text),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
