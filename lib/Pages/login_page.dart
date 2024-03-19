import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:telegraph/Auth/sign_in_google.dart';
import 'package:telegraph/Pages/register_page.dart';
import 'package:telegraph/Controller/user_controller.dart';
import 'package:telegraph/defaults.dart';
import 'package:telegraph/Widgets/error_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: deepPurple500,
        ),
      ),
      body: Center(
        child: pageBody(),
      ),
    );
  }

  // Body
  SizedBox pageBody() {
    return SizedBox(
      width: widthScreen(context) - 50.0,
      child: OrientationBuilder(
        builder: (context, orientation) {
          // The equivalent of the "smallestWidth" qualifier on Android.
          var shortestSide = MediaQuery.of(context).size.shortestSide;

          // Determine if we should use mobile layout or not, 600 here is
          // a common breakpoint for a typical 7-inch tablet.
          final bool useMobileLayout = shortestSide < 600;
          return orientationBasedWidget(orientation, useMobileLayout);
        },
      ),
    );
  }

  Widget orientationBasedWidget(Orientation orientation, bool mobileLayout) {
    // User changes orientation to portrait
    if (orientation == Orientation.portrait) {
      List<Widget> newContent = contents();
      newContent.add(expandedSignUp(mobileLayout));
      return Column(children: newContent);
    }
    // User changes orientation to landscape
    else {
      // Screen is mobile size
      List<Widget> newContent = contents();
      if (mobileLayout) {
        newContent.add(RegisterText(context: context));
        return ListView(children: newContent);
      }
      // Screen is tablet size
      else {
        newContent.add(expandedSignUp(mobileLayout));
        return Column(children: newContent);
      }
    }
  }

  Expanded expandedSignUp(bool mobileLayout) {
    // If device is a tablet, set the alignment of Register text to end.
    MainAxisAlignment registerTextAlignment =
        (mobileLayout ? MainAxisAlignment.center : MainAxisAlignment.end);

    return Expanded(
      child: Column(
        mainAxisAlignment: registerTextAlignment,
        children: [
          RegisterText(context: context),
        ],
      ),
    );
  }

  List<Widget> contents() {
    return [
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
        email: emailController,
        password: passwordController,
        context: context,
      ),
      const ForgotPassword(),
      const LoginWith(),
      const ThirdPartyLogin(),
      const PrivacyPolicy(),
    ];
  }
}

// The branding on top of all widget, 'Telegraph' 'Connecting the World'
class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        children: const [
          Text(
            "Telegraph",
            style: TextStyle(
              color: deepPurple500,
              fontSize: 48.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          Text(
            "Connecting the World",
            style: TextStyle(
              color: grey500,
              fontSize: 16.0,
              fontStyle: FontStyle.italic,
              letterSpacing: 1.0,
            ),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: widget.controller,
        decoration: inputDecoration(),
        obscureText: obscureText(),
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
      labelStyle: const TextStyle(color: black, fontSize: textSmall),
      enabledBorder: enableAndFocusBorder(1.0),
      focusedBorder: enableAndFocusBorder(2.0),
      suffixIcon: isPassword(),
      prefixIcon: startIcon,
    );
  }

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
  // always return false.
  bool obscureText() {
    if (widget.password) {
      return showPassword ? false : true;
    } else {
      return false;
    }
  }

  OutlineInputBorder enableAndFocusBorder(double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: deepPurple500, width: width),
    );
  }
}

// Login button authenticates with the firebase
class LoginButton extends StatelessWidget {
  final TextEditingController email;
  final TextEditingController password;
  final BuildContext context;

  const LoginButton({
    super.key,
    required this.email,
    required this.password,
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
              onPressed: initiateSignIn,
              child: buttonText(),
            ),
          ),
        ],
      ),
    );
  }

  void initiateSignIn() async {
    if (email.text == "" || password.text == "") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialogFunc(
            errorContent: 'Email and password cannot be empty.',
            optionPage: RegisterPage(),
            optionName: 'Register Instead',
          );
        },
      );
      return;
    }

    String? authenticate = await UserController().signInEmailPassword(
      email.text,
      password.text,
    );

    // If there is an error authenticating
    if (authenticate != 'Success') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialogFunc(
            errorContent: authenticate,
            optionPage: const RegisterPage(),
            optionName: 'Register Instead',
          );
        },
      );
    }
  }

  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(10.0),
      foregroundColor: white,
      backgroundColor: deepPurple500,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  Text buttonText() {
    return const Text(
      "LOGIN",
      style: TextStyle(
        fontSize: textbig,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
    );
  }
}

// If user forgots password
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
        child: const Center(
          child: Text(
            "Forgot your password?",
            style: TextStyle(
              color: lightBlue600,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}

// Seperator between the log in using email and the google button.
class LoginWith extends StatelessWidget {
  const LoginWith({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: contents(),
      ),
    );
  }

  List<Widget> contents() {
    return [
      const Expanded(
        child: Divider(
          height: 2.0,
          color: grey500,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: const Text(
          "or login with",
          style: TextStyle(color: grey500),
        ),
      ),
      const Expanded(
        child: Divider(
          height: 10.0,
          color: grey500,
        ),
      )
    ];
  }
}

// User can login with google
class ThirdPartyLogin extends StatelessWidget {
  const ThirdPartyLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: outlinedButton(),
          ),
        ],
      ),
    );
  }

  OutlinedButton outlinedButton() {
    return OutlinedButton.icon(
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
        style: TextStyle(color: black, fontSize: 16.0),
      ),
    );
  }
}

// Privacy policy and terms of use
class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        children: [
          byLoggingIn(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: contents(),
          ),
        ],
      ),
    );
  }

  Container byLoggingIn() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0),
      child: const Text(
        "By logging in you agree to Telegraph's",
        style: TextStyle(color: black),
      ),
    );
  }

  List<Widget> contents() {
    return [
      privacyAndTerms('Privacy Policy', () {}),
      Container(
        margin: const EdgeInsets.only(left: 2.0, right: 2.0),
        child: const Text(
          "and",
          style: TextStyle(color: black),
        ),
      ),
      privacyAndTerms('Terms of Use', () {}),
    ];
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
}

// This is the 'Sign up' text below the login button.
class RegisterText extends StatelessWidget {
  final BuildContext context;
  const RegisterText({Key? key, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(
              color: grey500,
              fontSize: textSmall,
            ),
          ),
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
              child: const Text(
                "Sign up",
                style: TextStyle(
                  color: lightBlue600,
                  fontWeight: FontWeight.bold,
                  fontSize: textSmall,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
