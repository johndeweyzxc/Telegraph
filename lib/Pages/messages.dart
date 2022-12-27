// ignore_for_file: depend_on_referenced_packages, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegraph/Auth/auth_instance.dart';
import 'package:telegraph/Pages/Widgets/sidebar_menu.dart';
import 'package:telegraph/const_var.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final User? user = AuthInstance().firebaseAuth.currentUser;

  AppBar appBar() {
    return AppBar(
      backgroundColor: productColor,
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
        children: const [
          Expanded(
            child: MessageView(),
          ),
          MessageInput(),
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
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  List<Map<dynamic, dynamic>> messageList = List.from([
    {
      'name': 'johndewey02003',
      'message':
          'Lorem Ipsum is simply dummy Lorem Ipsum is simply dummy Lorem Ipsum is simply dummy',
      'selfmessage': true,
    },
    {
      'name': 'johndewey02003',
      'message': 'Lorem Ipsum is simply dummy',
      'selfmessage': true,
    },
    {
      'name': 'johndewey02003',
      'message': 'Lorem Ipsum is simply dummy',
      'selfmessage': false,
    },
    {
      'name': 'johndewey02003',
      'message': 'Lorem Ipsum is simply dummy',
      'selfmessage': false,
    },
    {
      'name': 'johndewey02003',
      'message': 'Lorem Ipsum is simply dummy',
      'selfmessage': false,
    },
    {
      'name': 'johndewey02003',
      'message': 'Lorem Ipsum is simply dummy',
      'selfmessage': false,
    },
    {
      'name': 'johndewey02003',
      'message': 'Lorem Ipsum is simply dummy',
      'selfmessage': false,
    },
    {
      'name': 'johndewey02003',
      'message': 'Lorem Ipsum is simply dummy',
      'selfmessage': true,
    },
    {
      'name': 'johndewey02003',
      'message': 'Lorem Ipsum is simply dummy',
      'selfmessage': false,
    },
    {
      'name': 'johndewey02003',
      'message': 'Lorem Ipsum is simply dummy',
      'selfmessage': false,
    },
    {
      'name': 'johndewey02003',
      'message': 'Lorem Ipsum is simply dummy',
      'selfmessage': true,
    },
    {
      'name': 'johndewey02003',
      'message': 'Lorem Ipsum is simply dummy',
      'selfmessage': false,
    },
    {
      'name': 'johndewey02003',
      'message': 'Lorem Ipsum is simply dummy',
      'selfmessage': false,
    },
    {
      'name': 'johndewey02003',
      'message': 'Lorem Ipsum is simply dummy',
      'selfmessage': false,
    },
  ]);

  IndividualMessage viewMessage(String name, String message, bool selfMessage) {
    return IndividualMessage(
      name: name,
      message: message,
      selfMessage: selfMessage,
    );
  }

  ListView messageCreate() {
    return ListView.builder(
      itemCount: messageList.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        String name = messageList[index]['name'];
        String message = messageList[index]['message'];
        bool selfMessage = messageList[index]['selfmessage'];

        return viewMessage(name, message, selfMessage);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: messageCreate(),
    );
  }
}

class IndividualMessage extends StatelessWidget {
  final String name;
  final String message;
  final bool selfMessage;

  const IndividualMessage({
    super.key,
    required this.name,
    required this.message,
    required this.selfMessage,
  });

  Container avatar() {
    return Container(
      margin: const EdgeInsets.only(right: 5.0, left: 5.0),
      child: const CircleAvatar(),
    );
  }

  Container textName(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2.0, left: 5.0, right: 5.0),
      child: Text(
        name,
        style: const TextStyle(
          color: defaultGrey,
        ),
      ),
    );
  }

  Container textMessage(String message, bool selfMessage) {
    BoxDecoration messageBoxDecor = BoxDecoration(
      border: Border.all(
        color: selfMessage ? defaultBlue : defaultGrey,
        width: 1.0,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(55.0),
      ),
      color: selfMessage ? defaultBlue : defaultWhite,
    );

    TextStyle inputTextStyle = TextStyle(
      color: selfMessage ? defaultWhite : defaultBlack,
      fontSize: logintTextSizeSmall,
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

  Expanded messageInfo(String name, String message, bool selfMessage) {
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
      if (selfMessage) {
        return Row(
          children: [
            messageInfo(name, message, selfMessage),
            avatar(),
          ],
        );
      } else {
        return Row(
          children: [
            avatar(),
            messageInfo(name, message, selfMessage),
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
  const MessageInput({super.key});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  @override
  Widget build(BuildContext context) {
    TextEditingController inputController = TextEditingController();

    Container sendButton() {
      return Container(
        margin: const EdgeInsets.all(10.0),
        child: const Icon(Icons.send_outlined),
      );
    }

    Expanded textField() {
      OutlineInputBorder focusBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(color: productColor, width: 2.0),
      );

      OutlineInputBorder enableBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(color: productColor, width: 2.0),
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
