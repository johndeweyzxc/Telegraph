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
  Container pageBody() {
    return Container(
      width: widthScreen(context) - 50.0,
      child: Column(
        children: [
          const Welcome(),
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
          const ForgotPassword(),
          const LoginWith(),
          const ThirdPartyLogin(),
          const PrivacyPolicy(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RegisterText(context: context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(),
      body: Center(
        child: pageBody(),
      ),
    );
  }
}

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  final TextStyle appHeadingStyle = const TextStyle(
    color: productColor,
    fontSize: 48.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
  );

  final TextStyle subHeadingStyle = const TextStyle(
    color: defaultGrey,
    fontSize: 16.0,
    fontStyle: FontStyle.italic,
    letterSpacing: 1.0,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        children: [
          Text(
            "Telegraph",
            style: appHeadingStyle,
          ),
          Text(
            "Connecting the World",
            style: subHeadingStyle,
          )
        ],
      ),
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

  final TextStyle inputLabelStyle = const TextStyle(
    color: defaultBlack,
    fontSize: logintTextSizeSmall,
  );

  final OutlineInputBorder inputEnabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: productColor),
  );

  final OutlineInputBorder inputFocusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: productColor, width: 2.0),
  );

  @override
  Widget build(BuildContext context) {
    final Padding startIcon = Padding(
      padding: const EdgeInsets.all(10.0),
      child: Icon(
        widget.label == "Password" ? Icons.lock : Icons.mail,
        color: defaultBlack,
      ),
    );

    final InputDecoration inputDecoration = InputDecoration(
      contentPadding: const EdgeInsets.all(10.0),
      labelText: widget.label,
      labelStyle: inputLabelStyle,
      enabledBorder: inputEnabledBorder,
      focusedBorder: inputFocusedBorder,
      suffixIcon: isPassword(),
      prefixIcon: startIcon,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: widget.controller,
        decoration: inputDecoration,
        obscureText: obscureText(),
      ),
    );
  }
}

// Login button, takes signInWithEmailAndPassword Future to authenticate
class LoginButton extends StatelessWidget {
  final VoidCallback signIn;

  LoginButton({super.key, required this.signIn});

  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(10.0),
    foregroundColor: defaultWhite,
    backgroundColor: productColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  final Text buttonText = const Text(
    "LOGIN",
    style: TextStyle(
      fontSize: loginTextSizeBig,
      fontWeight: FontWeight.bold,
      letterSpacing: 2.0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(children: [
        Expanded(
          child: ElevatedButton(
            style: buttonStyle,
            onPressed: signIn,
            child: buttonText,
          ),
        ),
      ]),
    );
  }
}

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: GestureDetector(
        onTap: () {
          debugPrint("Forgot password!");
        },
        child: const Text(
          "Forgot your password?",
          style: TextStyle(
            color: defaultBlue,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}

class LoginWith extends StatelessWidget {
  const LoginWith({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(color: defaultGrey);

    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Divider(
              height: 2.0,
              color: defaultGrey,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: const Text("or login with", style: textStyle),
          ),
          const Expanded(
            child: Divider(
              height: 10.0,
              color: defaultGrey,
            ),
          ),
        ],
      ),
    );
  }
}

// User can login with google
class ThirdPartyLogin extends StatelessWidget {
  const ThirdPartyLogin({
    Key? key,
  }) : super(key: key);

  Container google() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.all(5.0),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: const MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
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
                style: TextStyle(color: defaultBlack, fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return google();
  }
}

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5.0),
            child: const Text(
              "By logging in you agree to Telegraph's",
              style: TextStyle(color: defaultBlack),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: const Text(
                  "Privacy Policy",
                  style: TextStyle(
                    color: defaultBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 2.0, right: 2.0),
                child: const Text(
                  "and",
                  style: TextStyle(color: defaultBlack),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  "Terms of Use.",
                  style: TextStyle(
                      color: defaultBlue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
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
      margin: const EdgeInsets.only(bottom: 15.0),
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
