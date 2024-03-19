import 'package:flutter/material.dart';

class ErrorDialogFunc extends StatelessWidget {
  final String? errorContent;
  final Widget? optionPage;
  final String? optionName;

  const ErrorDialogFunc({
    super.key,
    required this.errorContent,
    required this.optionPage,
    required this.optionName,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Ok"),
      ),
    ];

    if (optionPage != null) {
      widgetList.add(
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return optionPage!;
                },
              ),
            );
          },
          child: Text(optionName!),
        ),
      );
    }

    return AlertDialog(
      title: const Text("Error"),
      content: Text(errorContent!),
      actions: widgetList,
      elevation: 24.0,
    );
  }
}
