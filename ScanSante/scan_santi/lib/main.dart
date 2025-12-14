import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scan_santi/firebase_options.dart';
import 'package:scan_santi/routes_and_navigation/route_names.dart';
import 'package:scan_santi/routes_and_navigation/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      onGenerateRoute: Routes.generateRoute,
      initialRoute: RouteNames.homePage,
    );
  }
}
