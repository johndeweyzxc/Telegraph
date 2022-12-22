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

  AppBar appBarComponent() {
    return AppBar(
      backgroundColor: productColor,
      title: const Text("Register"),
    );
  }

  // This is where the email, password, confirm password and register button
  // is located.
  Column registerInputs() {
    return Column(
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
        const LoginInstead(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(),
      body: Center(child: registerInputs()),
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

  @override
  Widget build(BuildContext context) {
    InputDecoration decor = InputDecoration(
      contentPadding: const EdgeInsets.all(10.0),
      labelText: widget.label,
      labelStyle: const TextStyle(color: defaultBlack),
      border: const OutlineInputBorder(),
      enabledBorder: outline,
      focusedBorder: outline,
      suffixIcon: isPassword(),
    );

    return SizedBox(
      width: widthScreen(context) - 50.0,
      child: Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: TextFormField(
          controller: widget.controller,
          style: const TextStyle(fontSize: logintTextSizeSmall),
          decoration: decor,
          obscureText: obscureText(),
          maxLength: 40,
        ),
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
    var buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
      foregroundColor: defaultWhite,
      backgroundColor: productColor,
    );

    const TextStyle textStyle = TextStyle(
      fontSize: logintTextSizeSmall,
      fontWeight: FontWeight.bold,
      letterSpacing: 2.0,
    );

    return ElevatedButton(
      style: buttonStyle,
      onPressed: register,
      child: const Text(
        "REGISTER",
        style: textStyle,
      ),
    );
  }
}

// Login instead TextButton will go back to the login page of the app
class LoginInstead extends StatelessWidget {
  const LoginInstead({super.key});

  TextButton loginInsteadText(BuildContext context) {
    const TextStyle textStyle = TextStyle(
        color: defaultBlue, fontWeight: FontWeight.bold, fontSize: 16.0);

    return TextButton(
      onPressed: () {
        Navigator.of(context).pop(true);
      },
      child: const Text(
        "I have an account",
        style: textStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loginInsteadText(context),
    );
  }
}
