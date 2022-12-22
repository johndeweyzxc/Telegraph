// ignore_for_file: depend_on_referenced_packages, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:telegraph/Auth/sign_in_google.dart';
import 'package:telegraph/Auth/sign_in_email.dart';
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
  String? errorMessage = '';

  // Communicate with the firebase to authenticate user
  Future<void> signInWithEmailAndPassword() async {
    try {
      await EmailAuth().signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }

    debugPrint(errorMessage);
  }

  // AppBar
  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: productColor,
      ),
    );
  }

  // Body
  Column pageBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoginTextInput(
          label: "Email",
          password: false,
          controller: emailController,
        ),
        LoginTextInput(
          label: "Password",
          password: true,
          controller: passwordController,
        ),
        LoginButton(
          signIn: () async {
            await signInWithEmailAndPassword();
          },
        ),
        RegisterText(context: context),
        const DividerLine(),
        const LoginWith(),
        const ThirdPartyLogin(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(),
      body: pageBody(),
    );
  }
}

// Widget for getting email and password for authentication
class LoginTextInput extends StatefulWidget {
  final String label;
  final bool password;
  final TextEditingController controller;

  const LoginTextInput({
    super.key,
    required this.label,
    required this.password,
    required this.controller,
  });

  @override
  State<LoginTextInput> createState() => _TextInputState();
}

class _TextInputState extends State<LoginTextInput> {
  bool showPassword = false;

  // Returns an icon if the input type is password
  IconButton? isPassword() {
    if (widget.password) {
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

  // If the input type is password return either true or false otherwise
  // always return false
  bool obscureText() {
    if (widget.password) {
      return showPassword ? false : true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthScreen(context) - 50.0,
      child: Container(
        margin: const EdgeInsets.only(top: 15.0),
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10.0),
            labelText: widget.label,
            labelStyle: const TextStyle(
                color: defaultBlack, fontSize: logintTextSizeSmall),
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: const BorderSide(color: productColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: const BorderSide(color: productColor, width: 2.0),
            ),
            suffixIcon: isPassword(),
          ),
          obscureText: obscureText(),
        ),
      ),
    );
  }
}

// Login button, takes signInWithEmailAndPassword Future to authenticate
class LoginButton extends StatelessWidget {
  final VoidCallback signIn;

  const LoginButton({super.key, required this.signIn});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
          foregroundColor: defaultWhite,
          backgroundColor: productColor,
          shape: const StadiumBorder(),
        ),
        onPressed: signIn,
        child: const Text(
          "LOGIN",
          style: TextStyle(
            fontSize: loginTextSizeBig,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
      ),
    );
  }
}

// This is the 'Sign up' text below the login button, when tap goes to another
// page to register a new user.
class RegisterText extends StatelessWidget {
  const RegisterText({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    const TextStyle localStyle = TextStyle(
      color: defaultBlack,
      fontSize: 16.0,
    );

    const TextStyle signUpStyle = TextStyle(
      color: defaultBlue,
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    );

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Row(
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
      ),
    );
  }
}

// Divider between Sign up and login with
class DividerLine extends StatelessWidget {
  const DividerLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthScreen(context) - 50.0,
      margin: const EdgeInsets.only(top: 10.0),
      child: const Divider(color: defaultGrey),
    );
  }
}

class LoginWith extends StatelessWidget {
  const LoginWith({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(color: defaultGrey);

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: const Text("or login with", style: textStyle),
    );
  }
}

// User can login with google, facebook or apple
class ThirdPartyLogin extends StatelessWidget {
  const ThirdPartyLogin({
    Key? key,
  }) : super(key: key);

  Container google() {
    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      child: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
        onPressed: () {
          GoogleAuth().googleLogin();
        },
        icon: Image.asset(
          "assets/images/google-icon.png",
          height: 30.0,
        ),
        label: const Text(
          "Google",
          style: TextStyle(color: defaultBlack),
        ),
      ),
    );
  }

  ElevatedButton facebook() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color.fromARGB(255, 3, 155, 229),
        ),
      ),
      onPressed: () {
        debugPrint("Facebook!");
      },
      icon: Image.asset(
        "assets/images/facebook-icon.png",
        height: 30.0,
      ),
      label: const Text(
        "Facebook",
        style: TextStyle(color: defaultWhite),
      ),
    );
  }

  ElevatedButton apple() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(defaultWhite),
      ),
      onPressed: () {
        debugPrint("Apple!");
      },
      icon: Image.asset(
        "assets/images/apple-icon.png",
        height: 30.0,
      ),
      label: const Text(
        "Apple",
        style: TextStyle(
          color: defaultBlack,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              google(),
              facebook(),
            ],
          ),
          apple(),
        ],
      ),
    );
  }
}
