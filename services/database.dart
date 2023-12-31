import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_editor/code_editor.dart';



class DatabaseService{
  final String uid;



  DatabaseService({required this.uid});
  final CollectionReference fileEditors = FirebaseFirestore.instance.collection('f_editors');

  Future<void> addFileEditor(FileEditor fileEditor) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        await fileEditors.add({
          'user_token': uid,
          'file_name': fileEditor.name,
          'language': fileEditor.language,
          'code': fileEditor.code
        });
      });
      print('FileEditor added to Firestore!');
    } catch (e) {
      print('Error adding FileEditor to Firestore: $e');
    }
  }
  Future<String> uploadFile(FileEditor fileEditor) async {
    var fileName = fileEditor.name;
    var language = fileEditor.language;
    var code = fileEditor.code;

    try {
      DocumentReference<Map<String, dynamic>> documentReference = await fileEditors
          .doc(uid)
          .collection('language')
          .doc(language)
          .collection('files')
          .add({
        'file_name': fileName,
        'language': language,
        'code': code
      });

      // Get the document ID from the DocumentReference
      String documentId = documentReference.id;

      return documentId;
    } catch (e) {
      print('Error uploading file: $e');
      return "NO_FILE";
    }
  }

  Future<List<Map<String, FileEditor>>> getFiles(String language) async {

    var data = await fileEditors.doc(uid).collection('language').doc(language).collection('files').get();
    return List.from(data.docs.map((doc) => fileEditorOfDoc(doc)));
  }



  Map<String, FileEditor> fileEditorOfDoc(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    var data_id = doc.id;
    return {
        data_id: FileEditor( name: data['file_name'], language: data['language'], code: data['code'],)
    };
  }





  Future<void> deleteFileEditor(FileEditor fileEditor, String doc_id) async {
    var language = fileEditor.language;
    try {
      await fileEditors.doc(uid).collection('language').doc(language).collection('files').doc(doc_id).delete();
      print('FileEditor deleted from Firestore!');
    } catch (e) {
      print('Error deleting FileEditor from Firestore: $e');
    }
  }


  Future updateFile(FileEditor fileEditor, String _code, String doc_id) async {
    try {
      await fileEditors.doc(uid).collection('language').doc(fileEditor.language).collection('files').doc(doc_id).update({'code' : _code});
      print('FileEditor updated at Firestore!');
    } catch (e) {
      print('Error updating FileEditor at Firestore: $e');
    }
  }
}