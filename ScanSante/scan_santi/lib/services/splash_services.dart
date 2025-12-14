import 'package:firebase_auth/firebase_auth.dart';

import 'package:scan_santi/routes_and_navigation/route_names.dart';

class SplashServices {
  static String checkUserLogin() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      return RouteNames.homePage;
    } else {
      return RouteNames.signinScreen;
    }
  }
}
