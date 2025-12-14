import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scan_santi/services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    String screen = SplashServices.checkUserLogin();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, screen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
