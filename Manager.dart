

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_editor/code_editor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_2_files/services/auth_f.dart';
import 'package:testing_2_files/services/database_firestore.dart';

class Manager{

  static const String appName= "GogolCode";
  static late SharedPreferences prefs ;
  static late Authentication auth;
  static late String user_id;
  static late DatabaseService data_base;
  static FirebaseFirestore fileEditors = FirebaseFirestore.instance;

  Map<String,String> appData = {};

  static void loadAppData() async {
    auth = Authentication();

    prefs = await SharedPreferences.getInstance();
    await auth.init(prefs);

    String? aux_uid = prefs.getString('user_token');

    if(aux_uid != null){
      user_id = aux_uid;
      auth.userid = user_id;
      data_base = DatabaseService(uid_m: user_id, dataBaseEditors_m: fileEditors);
    }
    else{
      user_id = "";
      print(user_id);
      data_base = DatabaseService(uid_m: "", dataBaseEditors_m: fileEditors); }

  }

  static Future<String> logInManager({required String email, required String password,}) async {
    String result = await auth.logInUser(email: email, password: password);
    user_id = prefs.getString('user_token')!;
    data_base = DatabaseService(uid_m: user_id, dataBaseEditors_m: fileEditors);
    return result;
  }

  static Future<String> newUserManager({required String email, required String password,}) async {
    String result = await auth.newUser(email: email, password: password);
    user_id = prefs.getString('user_token')!;
    data_base = DatabaseService(uid_m: user_id, dataBaseEditors_m: fileEditors);
    return result;
  }

  static Future signOutManager(BuildContext context) async {
    await auth.signOut(context);
    user_id = "";
  }

  static Future<void> addFileEditorManager (FileEditor fileEditor){
    return data_base.addFileEditor(fileEditor);
  }

  static Future<String> uploadFileManager(FileEditor fileEditor){
    return data_base.uploadFile(fileEditor);
  }

  static Future<List<Map<String, FileEditor>>> getFilesManager(String language) {
    return data_base.getFiles(language);
  }

  static Future<void> deleteFileEditorManager(FileEditor fileEditor, String doc_id){
    return data_base.deleteFileEditor(fileEditor, doc_id);
  }

  static Future updateFileManager(FileEditor fileEditor, String _code, String doc_id){
    return data_base.updateFile(fileEditor, _code, doc_id);
  }











}


/*
Future<String> logInUser({required String email, required String password,}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        var out = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        prefs.setString('user_token', out.user!.uid);
        return 'success';
      }
    } catch (err) { return "Wrong or empty credentials";}
    return "Fill the fields properly";
  }

   Future<String> newUser({required String email, required String password,}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        var credentials = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        prefs.setString('user_token', credentials.user!.uid);
        return 'success';
      }
    } catch (err) { return "Try with other credentials"; }
    return "Fill the fields properly";
  }

  Future signOut(BuildContext context)  async{
    await _auth.signOut();
    userid = null;
    prefs.clear();
    Navigator.pushReplacementNamed(context, '/');

  }
 */
