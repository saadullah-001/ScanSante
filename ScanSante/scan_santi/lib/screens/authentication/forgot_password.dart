import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scan_santi/routes_and_navigation/route_names.dart';
import 'package:scan_santi/utilities/utils.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.2),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                "Forgot Password",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Text(
              "Enter your email address and we will send you a code to reset your password.",
            ),
            SizedBox(height: size.height * 0.04),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(96, 75, 72, 72),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 11),
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.11),
            SizedBox(
              height: 40,
              width: 180,
              child: ElevatedButton(
                onPressed: () {
                  _auth
                      .sendPasswordResetEmail(
                        email: _emailController.text.trim(),
                      )
                      .then((value) {
                        Navigator.pushNamed(context, RouteNames.emailSent);
                      })
                      .onError((error, stackTrace) {
                        Utils.toast(error.toString());
                      });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Send',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
