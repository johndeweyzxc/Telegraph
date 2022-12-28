import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? uname;
  final String? uemail;
  final String? uid;
  final String msg;
  final String photoUrl;
  final Timestamp timeStamp;

  const MessageModel({
    required this.uname,
    required this.uemail,
    required this.uid,
    required this.msg,
    required this.photoUrl,
    required this.timeStamp,
  });

  Map<String, dynamic> toJson() => {
        'uname': uname,
        'uemail': uemail,
        'uid': uid,
        'msg': msg,
        'photoUrl': photoUrl,
        'timeStamp': timeStamp,
      };

  static MessageModel fromJson(Map<String, dynamic> json) => MessageModel(
        uname: json['uname'],
        uemail: json['uemail'],
        uid: json['uid'],
        msg: json['msg'],
        photoUrl: json['photoUrl'],
        timeStamp: json['timeStamp'],
      );
}
