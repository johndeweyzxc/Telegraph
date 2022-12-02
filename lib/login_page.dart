import 'package:flutter/material.dart';
import 'const_var.dart';

class RootLoginPage extends StatelessWidget {
  const RootLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;

  // AppBar
  AppBar appBarComponent() {
    return AppBar(
      backgroundColor: productColor,
      title: const Text("Login or Register"),
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

  TextButton loginButton() {
    return TextButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        foregroundColor: defaultWhite,
        backgroundColor: productColor,
        shape: const StadiumBorder(),
      ),
      onPressed: () {
        debugPrint(userNameController.text);
        debugPrint(passwordController.text);
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

  Row register() {
    const TextStyle localStyle = TextStyle(
      color: defaultBlack,
      fontSize: 16.0,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?", style: localStyle),
        TextButton(
          style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
          onPressed: () {
            debugPrint("Register");
          },
          child: const Text("Sign up", style: localStyle),
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
            child: textInput("Username", false, userNameController),
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
            child: register(),
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
