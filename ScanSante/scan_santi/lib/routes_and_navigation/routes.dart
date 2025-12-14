import 'package:flutter/material.dart';
import 'package:scan_santi/models/food_analysis_model.dart';
import 'package:scan_santi/models/user_preferences.dart';
import 'package:scan_santi/screens/authentication/email_sent.dart';
import 'package:scan_santi/screens/authentication/forgot_password.dart';
import 'package:scan_santi/screens/authentication/otp_screen.dart';
import 'package:scan_santi/screens/authentication/password_changed.dart';
import 'package:scan_santi/screens/authentication/reset_password.dart';
import 'package:scan_santi/screens/authentication/signin_screen.dart';
import 'package:scan_santi/screens/authentication/signup_screen.dart';
import 'package:scan_santi/screens/authentication/splash_screen.dart';
import 'package:scan_santi/screens/comparison_screen.dart';
import 'package:scan_santi/screens/history_screen.dart';
import 'package:scan_santi/screens/home_page.dart';
import 'package:scan_santi/screens/profile_screen.dart';
import 'package:scan_santi/routes_and_navigation/route_names.dart';
import 'package:scan_santi/screens/result_screen.dart';
import 'package:scan_santi/screens/scan_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case RouteNames.homePage:
        return MaterialPageRoute(builder: (context) => HomePage());

      case RouteNames.historyScreen:
        return MaterialPageRoute(builder: (context) => History());

      case RouteNames.profileScreen:
        return MaterialPageRoute(builder: (context) => ProfileScreen());

      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (context) => ForgotPassword());

      case RouteNames.otpScreen:
        return MaterialPageRoute(builder: (context) => OtpScreen());

      case RouteNames.passwordChanged:
        return MaterialPageRoute(builder: (context) => PasswordChanged());

      case RouteNames.resetPassword:
        return MaterialPageRoute(builder: (context) => ResetPassword());

      case RouteNames.signinScreen:
        return MaterialPageRoute(builder: (context) => SigninScreen());

      case RouteNames.signupScreen:
        return MaterialPageRoute(builder: (context) => SignupScreen());

      case RouteNames.emailSent:
        return MaterialPageRoute(builder: (context) => EmailSentScreen());

      case RouteNames.splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());

      case RouteNames.scanScreen:
        UserPreferences prefs;
        FoodAnalysisModel? firstProduct;

        // SCENARIO 1: Coming from Home Screen (Only UserPreferences passed)
        if (setting.arguments is UserPreferences) {
          prefs = setting.arguments as UserPreferences;
          firstProduct = null; // No comparison happening yet
        }
        // SCENARIO 2: Coming from Result Screen (Map passed with Prefs + First Product)
        else if (setting.arguments is Map<String, dynamic>) {
          final args = setting.arguments as Map<String, dynamic>;
          prefs = args['userPrefs'];
          firstProduct = args['firstProduct'];
        }
        // FALLBACK (Should not happen, but prevents crash)
        else {
          prefs = UserPreferences();
          firstProduct = null;
        }

        return MaterialPageRoute(
          builder: (_) =>
              ScanScreen(userPrefs: prefs, firstProduct: firstProduct),
        );

      case RouteNames.compareScreen:
        final args = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ComparisonScreen(
            product1: args['first'],
            product2: args['second'],
          ),
        );

      // inside lib/routes_and_navigation/routes.dart

      case RouteNames.resultScreen:
        // FIX: Now we safely expect a Map
        final args = setting.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => ResultScreen(
            model: args['model'],
            userPrefs:
                args['userPrefs'], // Ensure ResultScreen constructor accepts this
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(body: Center(child: Text('Unknown Page')));
          },
        );
    }
  }
}
