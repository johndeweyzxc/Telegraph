import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegraph/Models/message_model.dart';

class MessageController {
  // Create a new document message
  Future createMessage(String? uname, String? uemail, String? uid, String msg,
      String photoUrl, Timestamp timeStamp) async {
    // Reference to the document
    final docMsg = FirebaseFirestore.instance.collection('messages').doc();

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

    // Create document and write data to Firebase
    await docMsg.set(messageJson);
  }

  // Retrieve all the message from the database
  Stream<List<MessageModel>> messageStream() {
    // Converts json data to message model object
    MessageModel modelObject(doc) {
      return MessageModel.fromJson(doc.data());
    }

    // Reference to the messages collection
    final colRef = FirebaseFirestore.instance.collection('messages');
    // Order them by date, recent message appears on the end of the list.
    final ordered = colRef.orderBy('timeStamp', descending: false);
    final data = ordered.snapshots();

    return data.map((snapshot) => snapshot.docs.map(modelObject).toList());
  }
}
