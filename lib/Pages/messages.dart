// ignore_for_file: depend_on_referenced_packages, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegraph/Auth/auth_instance.dart';
import 'package:telegraph/Models/message_model.dart';
import 'package:telegraph/Widgets/sidebar_menu.dart';
import 'package:telegraph/const_var.dart';
import 'package:telegraph/Controller/controller.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final User? user = AuthInstance().firebaseAuth.currentUser;

  AppBar appBar() {
    return AppBar(
      backgroundColor: deepPurple500,
      title: Container(
        width: widthScreen(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              "Messages",
            ),
          ],
        ),
      ),
    );
  }

  Container appBody() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: MessageView(user: user!),
          ),
          MessageInput(
            currentUser: user,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: SideBarMenu(
          photoUrl: user?.photoURL,
          email: user?.email,
          name: user?.displayName),
      body: Center(
        child: appBody(),
      ),
    );
  }
}

class MessageView extends StatefulWidget {
  final User user;
  const MessageView({super.key, required this.user});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  ListView listBuilder(List<MessageModel> messageData) {
    return ListView.builder(
      itemCount: messageData.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        MessageModel messageModel = messageData[index];

        return IndividualMessage(
          messageModel: messageModel,
          currentUser: widget.user,
        );
      },
    );
  }

  StreamBuilder messageContent() {
    return StreamBuilder<List<MessageModel>>(
      stream: Controller().messageStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint("Oops! Something went wrong");
        } else if (snapshot.hasData) {
          final message = snapshot.data!;
          return listBuilder(message);
        }

        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: messageContent(),
    );
  }
}

class IndividualMessage extends StatelessWidget {
  final MessageModel messageModel;
  final User currentUser;

  const IndividualMessage(
      {super.key, required this.messageModel, required this.currentUser});

  dynamic profileImage() {
    String localPhoto = 'assets/images/flutter-symbol.png';

    if (messageModel.photoUrl == 'No profile photo') {
      return AssetImage(localPhoto);
    } else {
      return NetworkImage(messageModel.photoUrl);
    }
  }

  Container avatar() {
    return Container(
      margin: const EdgeInsets.only(right: 5.0, left: 5.0),
      child: CircleAvatar(
        backgroundImage: profileImage(),
      ),
    );
  }

  Container textName(String? name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2.0, left: 5.0, right: 5.0),
      child: Text(
        name!,
        style: const TextStyle(
          color: grey500,
        ),
      ),
    );
  }

  Container textMessage(String message, bool selfMessage) {
    BoxDecoration messageBoxDecor = BoxDecoration(
      border: Border.all(
        color: selfMessage ? lightBlue600 : grey500,
        width: 1.0,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(55.0),
      ),
      color: selfMessage ? lightBlue600 : white,
    );

    TextStyle inputTextStyle = TextStyle(
      color: selfMessage ? white : black,
      fontSize: textSmall,
    );

    return Container(
      decoration: messageBoxDecor,
      padding: const EdgeInsets.all(10.0),
      child: Text(
        message,
        style: inputTextStyle,
      ),
    );
  }

  Expanded messageInfo(String? name, String message, bool selfMessage) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
            (selfMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start),
        children: [
          textName(name),
          textMessage(message, selfMessage),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Row content() {
      bool isSelfMessage = currentUser.uid == messageModel.uid;

      if (isSelfMessage) {
        return Row(
          children: [
            messageInfo(
              messageModel.uname,
              messageModel.msg,
              isSelfMessage,
            ),
            avatar(),
          ],
        );
      } else {
        return Row(
          children: [
            avatar(),
            messageInfo(
              messageModel.uname,
              messageModel.msg,
              isSelfMessage,
            ),
          ],
        );
      }
    }

    return Container(
      margin: const EdgeInsets.all(10.0),
      child: content(),
    );
  }
}

class MessageInput extends StatefulWidget {
  final User? currentUser;

  const MessageInput({super.key, required this.currentUser});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  String? createName() {
    User? currentUser = widget.currentUser;
    if (currentUser?.displayName == null || currentUser?.displayName == "") {
      List<String>? getName = currentUser?.email?.split('@');
      return getName!.first;
    } else {
      return currentUser?.displayName;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController inputController = TextEditingController();

    IconButton sendButton() {
      Timestamp currentTime = Timestamp.now();
      User? currentUser = widget.currentUser;
      dynamic photoUrl = currentUser?.photoURL ?? 'No profile photo';

      return IconButton(
        onPressed: () {
          Controller().createMessage(
            createName(),
            currentUser?.email,
            currentUser?.uid,
            inputController.text,
            photoUrl,
            currentTime,
          );
        },
        icon: const Icon(Icons.send_outlined),
      );
    }

    Expanded textField() {
      OutlineInputBorder focusBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(color: deepPurple500, width: 2.0),
      );

      OutlineInputBorder enableBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(color: deepPurple500, width: 2.0),
      );

      EdgeInsets paddingX = const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      );

      return Expanded(
        child: TextField(
          textAlignVertical: TextAlignVertical.top,
          controller: inputController,
          decoration: InputDecoration(
            focusedBorder: focusBorder,
            enabledBorder: enableBorder,
            contentPadding: paddingX,
            hintText: "Send a message",
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(15.0),
      width: widthScreen(context),
      child: Row(
        children: [
          textField(),
          sendButton(),
        ],
      ),
    );
  }
}
