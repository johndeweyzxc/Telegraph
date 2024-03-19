import 'package:flutter/material.dart';
import 'package:telegraph/Pages/login_page.dart';
import 'package:telegraph/defaults.dart';
import 'package:telegraph/Controller/user_controller.dart';
import 'package:telegraph/Widgets/error_dialog.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: deepPurple500,
        title: const Text("Create an account"),
      ),
      body: Center(
        child: SizedBox(
          width: widthScreen(context) - 50.0,
          child: pageBody(),
        ),
      ),
    );
  }

  Container logInInstead() {
    return Container(
      margin: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          LoginInstead(),
        ],
      ),
    );
  }

  Expanded expandedInputs(List<Widget> views) {
    return Expanded(
      flex: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: views,
      ),
    );
  }

  Column columnView(contents) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: contents,
          ),
        ),
        const Expanded(
          child: LoginInstead(),
        ),
      ],
    );
  }

  // The list of the widget from email inputs up to privacy policy
  List<Widget> contents() {
    return [
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
        emailCtrl: emailController,
        passwordCtrl: passwordController,
        confirmCtrl: confirmController,
        context: context,
      ),
      const PrivacyPolicy(),
    ];
  }

  Widget orientationBasedWidget(Orientation orientation, bool mobileLayout) {
    // User changes orientation to portrait
    if (orientation == Orientation.portrait) {
      return columnView(contents());
    }
    // User changes orientation to landscape
    else {
      List<Widget> newContent = contents();
      newContent.add(logInInstead());
      // Screen is mobile size
      if (mobileLayout) {
        return ListView(
          children: newContent,
        );
      }
      // Screen is tablet size
      else {
        return columnView(contents());
      }
    }
  }

  // This is where the email, password, confirm password and register button
  // is located.
  OrientationBuilder pageBody() {
    return OrientationBuilder(
      builder: (context, orientation) {
        // The equivalent of the "smallestWidth" qualifier on Android.
        var shortestSide = MediaQuery.of(context).size.shortestSide;

        // Determine if we should use mobile layout or not, 600 here is
        // a common breakpoint for a typical 7-inch tablet.
        final bool useMobileLayout = shortestSide < 600;
        return orientationBasedWidget(orientation, useMobileLayout);
      },
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
      child: TextFormField(
        controller: widget.controller,
        style: const TextStyle(fontSize: textSmall),
        decoration: inputDecoration(),
        obscureText: obscureText(),
        maxLength: 40,
      ),
    );
  }

  InputDecoration inputDecoration() {
    Padding startIcon = Padding(
      padding: const EdgeInsets.all(10.0),
      child: Icon(
        widget.label == "Password" ? Icons.lock : Icons.mail,
        color: black,
      ),
    );

    return InputDecoration(
      contentPadding: const EdgeInsets.all(10.0),
      labelText: widget.label,
      labelStyle: const TextStyle(color: black),
      border: const OutlineInputBorder(),
      enabledBorder: focusAndEnableBorder(1.0),
      focusedBorder: focusAndEnableBorder(2.0),
      suffixIcon: isPassword(),
      prefixIcon: startIcon,
    );
  }

  OutlineInputBorder focusAndEnableBorder(double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: deepPurple500, width: width),
    );
  }

  IconButton isPassword() {
    // Input type is password
    if (widget.password) {
      return IconButton(
        onPressed: () {
          setState(() {
            showPassword = !showPassword;
          });
        },
        icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
      );
    }
    // Input type is not a password
    else {
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
}

// Register button to create a new user
class RegisterButton extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController confirmCtrl;
  final BuildContext context;

  const RegisterButton({
    super.key,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.confirmCtrl,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: buttonStyle(),
              onPressed: submitNewAccount,
              child: buttonText(),
            ),
          ),
        ],
      ),
    );
  }

  void submitNewAccount() async {
    // Password and confirm password did not match
    if (passwordCtrl.text != confirmCtrl.text) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialogFunc(
            errorContent: 'Those passwords did not match',
            optionPage: null,
            optionName: null,
          );
        },
      );
      return;
    }

    String? signUp = await UserController().signUpEmailPassword(
      emailCtrl.text,
      passwordCtrl.text,
    );

    String? errorContent = signUp;
    if (signUp == "Given String is empty or null") {
      errorContent = "Some input text field are empty.";
    }

    // If therer is an error creating a user account
    if (signUp != 'Success') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialogFunc(
            errorContent: errorContent,
            optionPage: const LoginPage(),
            optionName: "Login Instead",
          );
        },
      );
    }
  }

  Text buttonText() {
    return const Text(
      "REGISTER",
      style: TextStyle(
        fontSize: textbig,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
    );
  }

  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
      foregroundColor: white,
      backgroundColor: deepPurple500,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
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
          bySigningUp(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              privacyAndTerms('Privacy Policy', () {}),
              seperator(),
              privacyAndTerms('Terms of Use', () {}),
            ],
          )
        ],
      ),
    );
  }

  GestureDetector privacyAndTerms(String text, VoidCallback onTapCallback) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Text(
        text,
        style: const TextStyle(
          color: lightBlue600,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container seperator() {
    return Container(
      margin: const EdgeInsets.only(left: 2.0, right: 2.0),
      child: const Text(
        "and",
        style: TextStyle(color: black),
      ),
    );
  }

  Container bySigningUp() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0),
      child: const Text(
        "By signing up you agree to Telegraph's",
        style: TextStyle(color: black),
      ),
    );
  }
}

// Login instead TextButton will go back to the login page of the app
class LoginInstead extends StatelessWidget {
  const LoginInstead({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        haveAccount(),
        loginInstead(),
      ],
    );
  }

  Text haveAccount() {
    return const Text(
      "Have an account?",
      style: TextStyle(
        color: grey500,
        fontSize: textSmall,
      ),
    );
  }

  Container loginInstead() {
    return Container(
      margin: const EdgeInsets.only(left: 5.0),
      child: GestureDetector(
        onTap: () {},
        child: const Text(
          "Login instead",
          style: TextStyle(
            color: lightBlue600,
            fontSize: textSmall,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
