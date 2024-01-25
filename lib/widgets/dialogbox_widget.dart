import 'package:flutter/material.dart';

class DialogBoxWidget extends StatelessWidget {
  const DialogBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text(
        'About App',
        style: TextStyle(),
        textAlign: TextAlign.center,
      ),
      content: Text(
        'This app is  created by .. using flutter'
        '\n . The link to the github file is below \n',
        style: TextStyle(fontSize: 17),
      ),
    );
  }
}
