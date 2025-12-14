import 'package:flutter/material.dart';

class PasswordChanged extends StatefulWidget {
  const PasswordChanged({super.key});

  @override
  State<PasswordChanged> createState() => _PasswordChangedState();
}

class _PasswordChangedState extends State<PasswordChanged> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Password Changed",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 130),
              child: Text(
                "Your password has been chnaged successfully",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
