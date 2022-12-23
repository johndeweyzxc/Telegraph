// ignore_for_file: sized_box_for_whitespace, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegraph/const_var.dart';
import 'package:telegraph/Auth/sign_in_email.dart';

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
  String? errorMessage = '';

  // Communicate with the firebase to create a new user
  Future<void> createUserWithEmailAndPassword() async {
    // Password and confirm password did not match
    if (passwordController.text != confirmController.text) {
      debugPrint("Password does not match!");
      return;
    }

    try {
      await EmailAuth().createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }

    debugPrint(errorMessage);
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: productColor,
      title: const Text("Create an account"),
    );
  }

  // This is where the email, password, confirm password and register button
  // is located.
  Container pageBody() {
    return Container(
      width: widthScreen(context) - 50.0,
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RegisterInput(
                  label: "Email",
                  password: false,
                  controller: emailController,
                ),
                RegisterInput(
                  label: "Password",
                  password: true,
                  controller: passwordController,
                ),
                RegisterInput(
                  label: "Confirm Password",
                  password: true,
                  controller: confirmController,
                ),
                RegisterButton(
                  register: () async {
                    await createUserWithEmailAndPassword();
                  },
                ),
                const PrivacyPolicy(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  LoginInstead(),
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

// Text field input to get user information such as email and password.
class RegisterInput extends StatefulWidget {
  final String label;
  final bool password;
  final TextEditingController controller;

  const RegisterInput({
    super.key,
    required this.label,
    required this.password,
    required this.controller,
  });

  @override
  State<RegisterInput> createState() => _RegisterInputState();
}

class _RegisterInputState extends State<RegisterInput> {
  bool showPassword = false;
  OutlineInputBorder outline = const OutlineInputBorder(
    borderSide: BorderSide(color: productColor),
  );

  // Returns an icon 'visibility' if the input type is password,
  // otherwise return a 'close' icon
  IconButton isPassword() {
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
      return IconButton(
        onPressed: () {
          widget.controller.clear();
        },
        icon: const Icon(Icons.close),
      );
    }
  }

  bool obscureText() {
    if (widget.password) {
      return showPassword ? false : true;
    } else {
      return false;
    }
  }

  final OutlineInputBorder inputEnabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: productColor),
  );

  final OutlineInputBorder inputFocusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: productColor, width: 2.0),
  );

  InputDecoration inputDecoration() {
    Padding startIcon = Padding(
      padding: const EdgeInsets.all(10.0),
      child: Icon(
        widget.label == "Password" ? Icons.lock : Icons.mail,
        color: defaultBlack,
      ),
    );

    return InputDecoration(
      contentPadding: const EdgeInsets.all(10.0),
      labelText: widget.label,
      labelStyle: const TextStyle(color: defaultBlack),
      border: const OutlineInputBorder(),
      enabledBorder: inputEnabledBorder,
      focusedBorder: inputFocusedBorder,
      suffixIcon: isPassword(),
      prefixIcon: startIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: widget.controller,
        style: const TextStyle(fontSize: logintTextSizeSmall),
        decoration: inputDecoration(),
        obscureText: obscureText(),
        maxLength: 40,
      ),
    );
  }
}

// Register button to create a new user
class RegisterButton extends StatelessWidget {
  final VoidCallback register;

  const RegisterButton({super.key, required this.register});

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
      foregroundColor: defaultWhite,
      backgroundColor: productColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
    );

    Text buttonText = const Text(
      "REGISTER",
      style: TextStyle(
        fontSize: loginTextSizeBig,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: buttonStyle,
              onPressed: register,
              child: buttonText,
            ),
          ),
        ],
      ),
    );
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
              "By signing up you agree to Telegraph's",
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

// Login instead TextButton will go back to the login page of the app
class LoginInstead extends StatelessWidget {
  const LoginInstead({super.key});

  Text loginInsteadText() {
    const TextStyle textStyle = TextStyle(color: defaultBlue);

    return const Text(
      "Login instead?",
      style: textStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Have an account?",
            style: TextStyle(
              color: defaultGrey,
              fontSize: logintTextSizeSmall,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 5.0),
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                "Login instead",
                style: TextStyle(
                  color: defaultBlue,
                  fontSize: logintTextSizeSmall,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
