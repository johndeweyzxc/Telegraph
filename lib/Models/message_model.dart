class MessageModel {
  final String? uname;
  final String? uemail;
  final String? uid;
  final String msg;
  final String photoUrl;
  final int timeStamp;

  const MessageModel({
    required this.uname,
    required this.uemail,
    required this.uid,
    required this.msg,
    required this.photoUrl,
    required this.timeStamp,
  });

  Map<dynamic, dynamic> toJson() => {
        'uname': uname,
        'uemail': uemail,
        'uid': uid,
        'msg': msg,
        'photoUrl': photoUrl,
        'timeStamp': timeStamp,
      };

  static MessageModel fromJson(Map<dynamic, dynamic> json) => MessageModel(
        uname: json['uname'],
        uemail: json['uemail'],
        uid: json['uid'],
        msg: json['msg'],
        photoUrl: json['photoUrl'],
        timeStamp: json['timeStamp'],
      );
}
