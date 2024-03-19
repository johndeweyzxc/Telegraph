import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegraph/Auth/auth_instance.dart';
import 'package:telegraph/Models/message_model.dart';
import 'package:telegraph/Widgets/sidebar_menu.dart';
import 'package:telegraph/defaults.dart';
import 'package:telegraph/Controller/message_controller.dart';
import 'package:telegraph/Widgets/error_dialog.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final User? user = AuthInstance().firebaseAuth.currentUser;
  final ScrollController scrollController = ScrollController();

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

  AppBar appBar() {
    return AppBar(
      backgroundColor: deepPurple500,
      title: SizedBox(
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

  Column appBody() {
    return Column(
      children: [
        Expanded(
          child: MessageView(
            user: user!,
            scrollController: scrollController,
          ),
        ),
        MessageInput(
          currentUser: user,
          scrollController: scrollController,
        ),
      ],
    );
  }
}

class MessageView extends StatefulWidget {
  final User user;
  final ScrollController scrollController;
  const MessageView({
    super.key,
    required this.user,
    required this.scrollController,
  });

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream: MessageController().messageStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Debug error
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

  ListView listBuilder(List<MessageModel> messageData) {
    if (widget.scrollController.hasClients) {
      Future.delayed(const Duration(microseconds: 500)).then(
        (value) => {
          widget.scrollController.animateTo(
            widget.scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          ),
        },
      );
    }

    return ListView.builder(
      itemCount: messageData.length,
      scrollDirection: Axis.vertical,
      controller: widget.scrollController,
      itemBuilder: (BuildContext context, int index) {
        MessageModel messageModel = messageData[index];

        return IndividualMessage(
          messageModel: messageModel,
          currentUser: widget.user,
          scrollController: widget.scrollController,
        );
      },
    );
  }
}

class IndividualMessage extends StatelessWidget {
  final MessageModel messageModel;
  final User currentUser;
  final ScrollController scrollController;

  const IndividualMessage({
    super.key,
    required this.messageModel,
    required this.currentUser,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    Row content() {
      bool isSelfMessage = currentUser.email == messageModel.uemail;

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

  dynamic profileImage() {
    String localPhoto = 'assets/images/flutter-symbol.png';
    String startingUrl = 'https://lh3.googleusercontent.com/a/';
    String uniqueUrl = messageModel.photoUrl;

    if (messageModel.photoUrl == '') {
      return AssetImage(localPhoto);
    } else {
      return NetworkImage('$startingUrl$uniqueUrl');
    }
  }

  Container avatar() {
    return Container(
      margin: const EdgeInsets.only(right: 5.0, left: 5.0),
      child: CircleAvatar(
        backgroundColor: white,
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
}

class MessageInput extends StatefulWidget {
  final User? currentUser;
  final ScrollController scrollController;

  const MessageInput({
    super.key,
    required this.currentUser,
    required this.scrollController,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController inputController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
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

  String formatPhotoUrl(String url) {
    List<String> substrings = url.split("com/a/");
    return substrings.last;
  }

  IconButton sendButton() {
    Timestamp currentTime = Timestamp.now();
    User? currentUser = widget.currentUser;
    String photoUrl = currentUser?.photoURL ?? '';
    String formattedUrl = photoUrl != '' ? formatPhotoUrl(photoUrl) : '';

    return IconButton(
      onPressed: () {
        if (inputController.text.isEmpty) {
          return;
        }

        if (inputController.text.length >= 200) {
          inputController.clear();
          focusNode.unfocus();
          showDialog(
            context: context,
            builder: (BuildContext cotext) {
              return const ErrorDialogFunc(
                errorContent:
                    'Text length greater than 200 characters is not allowed.',
                optionPage: null,
                optionName: null,
              );
            },
          );
          return;
        }

        MessageController()
            .createMessage(
              createName(),
              currentUser?.email,
              inputController.text,
              formattedUrl,
              currentTime,
            )
            .then((value) => {removeFocusAndScroll()});
      },
      icon: const Icon(Icons.send_outlined),
    );
  }

  // After sending a message, clear the text on the textfield, remove focus
  // on the textfield and scroll to the end of the list.
  void removeFocusAndScroll() {
    inputController.clear();
    focusNode.unfocus();
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent - 5.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      },
    );
  }

  Expanded textField() {
    OutlineInputBorder focusAndEnable = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50.0),
      borderSide: const BorderSide(color: deepPurple500, width: 2.0),
    );

    return Expanded(
      child: TextField(
        focusNode: focusNode,
        textAlignVertical: TextAlignVertical.top,
        controller: inputController,
        decoration: InputDecoration(
          focusedBorder: focusAndEnable,
          enabledBorder: focusAndEnable,
          contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
          hintText: "Send a message",
        ),
      ),
    );
  }

  String? createName() {
    User? currentUser = widget.currentUser;
    if (currentUser?.displayName == null || currentUser?.displayName == "") {
      List<String>? getName = currentUser?.email?.split('@');
      return getName!.first;
    } else {
      return currentUser?.displayName;
    }
  }
}
