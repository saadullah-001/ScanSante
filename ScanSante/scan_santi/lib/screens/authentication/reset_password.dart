import 'package:flutter/material.dart';
import 'package:scan_santi/routes_and_navigation/route_names.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.3),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                "Reset Password",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.07),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(96, 75, 72, 72),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 11),
                  hintText: "New Password",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(96, 75, 72, 72),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 11),
                  hintText: "Confirm Password",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.12),
            SizedBox(
              height: 40,
              width: 180,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.passwordChanged);
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
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
