import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:telegraph/Models/message_model.dart';

class MessageController {
  // Create a new document message
  Future createMessage(String? uname, String? uemail, String msg,
      String photoUrl, Timestamp timeStamp) async {
    // Reference to the document
    final docMsg = FirebaseFirestore.instance.collection('messages').doc();

    final messageModel = MessageModel(
      uname: uname,
      uemail: uemail,
      msg: msg,
      photoUrl: photoUrl,
      timeStamp: timeStamp,
    );
    // Convert the message model object to json
    final messageJson = messageModel.toJson();

    // Create document and write data to Firebase
    await docMsg
        .set(messageJson)
        .then((value) => {
              debugPrint(
                  "[DEBUG PRINT] -> Successfully saved data to the database")
            })
        .onError(
            (error, stackTrace) => {debugPrint('[DEBUG PRINT] -> $error')});
  }

  // Retrieve all the message from the database
  Stream<List<MessageModel>> messageStream() {
    // Converts json data to message model object
    MessageModel modelObject(doc) {
      return MessageModel.fromJson(doc.data());
    }

    // Reference to the messages collection
    final colRef = FirebaseFirestore.instance.collection('messages');
    // Order the messages by timestamp, most recent last
    final ordered =
        colRef.orderBy('timeStamp', descending: false).limitToLast(30);
    final data = ordered.snapshots();

    return data.map((snapshot) => snapshot.docs.map(modelObject).toList());
  }
}
