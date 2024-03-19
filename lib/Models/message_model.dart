import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? uname;
  final String? uemail;
  final String msg;
  final String photoUrl;
  final Timestamp timeStamp;

  const MessageModel({
    required this.uname,
    required this.uemail,
    required this.msg,
    required this.photoUrl,
    required this.timeStamp,
  });

  Map<String, dynamic> toJson() => {
        'uname': uname,
        'uemail': uemail,
        'msg': msg,
        'photoUrl': photoUrl,
        'timeStamp': timeStamp,
      };

  static MessageModel fromJson(Map<String, dynamic> json) => MessageModel(
        uname: json['uname'],
        uemail: json['uemail'],
        msg: json['msg'],
        photoUrl: json['photoUrl'],
        timeStamp: json['timeStamp'],
      );
}
