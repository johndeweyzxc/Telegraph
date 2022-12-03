// ignore_for_file: sized_box_for_whitespace, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegraph/const_var.dart';
import 'package:telegraph/google_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool showPassword = false;
  bool passwordNotMatch = false;
  String? errorMessage = '';

  // Communicate with the firebase to create a new user
  Future<void> createUserWithEmailAndPassword() async {
    // Password and confirm password did not match
    if (passwordController.text != confirmController.text) {
      setState(() {
        passwordNotMatch = true;
      });
      return;
    } else {
      setState(() {
        passwordNotMatch = false;
      });
    }

    try {
      await GoogleAuth().createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }

    print(GoogleAuth().currentUser);

    debugPrint(errorMessage);
  }

  AppBar appBarComponent() {
    return AppBar(
      backgroundColor: productColor,
      title: const Text("Register"),
    );
  }

  // Returns an icon 'visibility' if the input type is password,
  // otherwise return a 'close' icon
  IconButton isPassword(bool password) {
    if (password) {
      return IconButton(
        onPressed: () {
          setState(() {
            showPassword = !showPassword;
          });
        },
        icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
      );
    } else {
      return IconButton(
        onPressed: () {
          emailController.clear();
        },
        icon: const Icon(Icons.close),
      );
    }
  }

  bool obscureText(bool password) {
    if (password) {
      return showPassword ? false : true;
    } else {
      return false;
    }
  }

  // Text input for email, password and confirm password
  TextFormField registerTextInput(
      String label, bool password, TextEditingController controller) {
    OutlineInputBorder outline = const OutlineInputBorder(
      borderSide: BorderSide(color: productColor),
    );

    String? returnError() {
      if (label == "Confirm Password") {
        return passwordNotMatch ? "Password did not match" : null;
      }
      return null;
    }

    InputDecoration decor = InputDecoration(
      contentPadding: const EdgeInsets.all(10.0),
      labelText: label,
      labelStyle: const TextStyle(color: defaultBlack),
      border: const OutlineInputBorder(),
      enabledBorder: outline,
      focusedBorder: outline,
      suffixIcon: isPassword(password),
      errorText: returnError(),
    );

    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: logintTextSizeSmall),
      decoration: decor,
      obscureText: obscureText(password),
      maxLength: 40,
    );
  }

  // Submit button to send all user credential to the database
  ElevatedButton registerButton() {
    final buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
      foregroundColor: defaultWhite,
      backgroundColor: productColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );

    const TextStyle textStyle = TextStyle(
      fontSize: logintTextSizeSmall,
      fontWeight: FontWeight.bold,
      letterSpacing: 2.0,
    );

    return ElevatedButton(
      style: buttonStyle,
      onPressed: () {
        createUserWithEmailAndPassword();
      },
      child: const Text(
        "REGISTER",
        style: textStyle,
      ),
    );
  }

  // This is where the email, password, confirm password and register button
  // is located.
  Column registerInputs() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            padding: loginDefaultPadding,
            child: registerTextInput("Email", false, emailController),
          ),
        ),
        Flexible(
          child: Container(
            padding: loginDefaultPadding,
            child: registerTextInput("Password", true, passwordController),
          ),
        ),
        Flexible(
          child: Container(
            padding: loginDefaultPadding,
            child:
                registerTextInput("Confirm Password", true, confirmController),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 0.0),
            width: widthScreen(context),
            child: registerButton(),
          ),
        ),
      ],
    );
  }

  // Body
  Container appBody() {
    return Container(
      width: widthScreen(context),
      height: heightScreen(context),
      child: registerInputs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(),
      body: appBody(),
    );
  }
}
