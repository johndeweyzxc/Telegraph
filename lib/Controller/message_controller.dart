import 'package:flutter/cupertino.dart';
import 'package:telegraph/Models/message_model.dart';
import 'package:firebase_database/firebase_database.dart';

class MessageController {
  // Create a new document message
  Future createMessage(String? uname, String? uemail, String? uid, String msg,
      String photoUrl, int timeStamp) async {
    // Reference to the document
    final DatabaseReference firebaseRef = FirebaseDatabase.instance.ref();

    final messageModel = MessageModel(
      uname: uname,
      uemail: uemail,
      uid: uid,
      msg: msg,
      photoUrl: photoUrl,
      timeStamp: timeStamp,
    );
    // Convert the message model object to json
    final messageJson = messageModel.toJson();
    String? key = firebaseRef.push().key;
    // Write data to the path database/messages
    await firebaseRef
        .child('Messages/$key')
        .set(messageJson)
        .then((value) => {
              debugPrint(
                  '[DEBUG PRINT] -> Successfully saved data to the database')
            })
        .onError(
            (error, stackTrace) => {debugPrint('[DEBUG PRINT] -> $error')});
  }
}
