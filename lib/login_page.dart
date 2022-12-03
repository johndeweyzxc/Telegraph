// ignore_for_file: depend_on_referenced_packages, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegraph/google_auth.dart';
import 'package:telegraph/register_page.dart';
import 'package:telegraph/const_var.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  String? errorMessage = '';

  // Communicate with the firebase to authenticate user
  Future<void> signInWithEmailAndPassword() async {
    try {
      await GoogleAuth().signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }

    debugPrint(errorMessage);
  }

  // AppBar
  AppBar appBarComponent() {
    return AppBar(
      backgroundColor: productColor,
      title: const Text("Login"),
    );
  }

  // Returns an icon if the input type is password
  IconButton? isPassword(bool password) {
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
      return null;
    }
  }

  // If the input type is password
  bool obscureText(bool password) {
    if (password) {
      return showPassword ? false : true;
    } else {
      return false;
    }
  }

  TextFormField textInput(
      String label, bool password, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: logintTextSizeSmall),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10.0),
        labelText: label,
        labelStyle: const TextStyle(color: defaultBlack),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: const BorderSide(color: productColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: const BorderSide(color: productColor),
        ),
        suffixIcon: isPassword(password),
      ),
      maxLength: 20,
      obscureText: obscureText(password),
    );
  }

  ElevatedButton loginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        foregroundColor: defaultWhite,
        backgroundColor: productColor,
        shape: const StadiumBorder(),
      ),
      onPressed: () {
        signInWithEmailAndPassword();
      },
      child: const Text(
        "LOGIN",
        style: TextStyle(
          fontSize: loginTextSizeBig,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Row registerButton() {
    const TextStyle localStyle = TextStyle(
      color: defaultBlack,
      fontSize: 16.0,
    );

    const TextStyle signUpStyle = TextStyle(
      color: defaultBlue,
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?", style: localStyle),
        Container(
          margin: const EdgeInsets.only(left: 5.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const RegisterPage();
                }),
              );
            },
            child: const Text("Sign up", style: signUpStyle),
          ),
        ),
      ],
    );
  }

  Row thirdPartyLogin() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: null,
          child: IconButton(
            onPressed: () {
              debugPrint("Google!");
            },
            icon: Image.asset("assets/images/google-icon.png"),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: IconButton(
            onPressed: () {
              debugPrint("Facebook!");
            },
            icon: Image.asset("assets/images/facebook-icon.png"),
          ),
        ),
        Container(
          margin: null,
          child: IconButton(
            onPressed: () {
              debugPrint("Apple!");
            },
            icon: Image.asset("assets/images/apple-icon.png"),
          ),
        ),
      ],
    );
  }

  Column loginInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            padding: loginDefaultPadding,
            child: textInput("Username", false, emailController),
          ),
        ),
        Flexible(
          child: Container(
            padding: loginDefaultPadding,
            child: textInput("Password", true, passwordController),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 0.0),
            width: widthScreen(context),
            child: loginButton(),
          ),
        ),
        Flexible(
          child: Container(
            padding: loginSecondaryPadding,
            child: registerButton(),
          ),
        ),
        Flexible(
          child: Container(
            padding: loginSecondaryPadding,
            child: const Divider(
              color: defaultGrey,
            ),
          ),
        ),
        Flexible(
          child: Container(
            padding: loginSecondaryPadding,
            child: const Text(
              "or login with",
              style: TextStyle(
                color: defaultGrey,
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            padding: loginDefaultPadding,
            child: thirdPartyLogin(),
          ),
        ),
      ],
    );
  }

  // Body
  Container pageBody() {
    return Container(
      width: widthScreen(context),
      height: heightScreen(context),
      child: loginInput(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBarComponent(),
      body: pageBody(),
    );
  }
}
