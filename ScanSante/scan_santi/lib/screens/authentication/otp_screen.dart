import 'package:flutter/material.dart';
import 'package:scan_santi/routes_and_navigation/route_names.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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
                "OTP Confirmation",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Enter the code sent at your email"),
            ),
            SizedBox(height: size.height * 0.01),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(96, 75, 72, 72),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 11),
                  hintText: "OTP",
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.resetPassword);
                  },
                  child: Text(
                    'Reset Password',
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
