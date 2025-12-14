import 'package:flutter/material.dart';
import 'package:scan_santi/routes_and_navigation/route_names.dart';

class EmailSentScreen extends StatefulWidget {
  const EmailSentScreen({super.key});

  @override
  State<EmailSentScreen> createState() => _EmailSentScreenState();
}

class _EmailSentScreenState extends State<EmailSentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "E-mail has been sent",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                "Kindly check your inbox to reset your password, if you don't find it there check spam folder.",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 21),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.signinScreen);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Return to Login',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
