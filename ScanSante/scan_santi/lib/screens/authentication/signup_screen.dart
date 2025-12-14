import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scan_santi/routes_and_navigation/route_names.dart';
import 'package:scan_santi/utilities/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isLoading = false;
  bool show = false;

  // @override
  // void initState() {
  //   super.initState();
  //   GoogleSignIn.instance.initialize();
  // }

  void login() async {
    setState(() => isLoading = true);

    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text.trim(),
      );

      // Send verification email
      await cred.user!.sendEmailVerification();

      Utils.toast("Verification email sent. Please verify then login.");

      // Optional but recommended: sign out so they can't use app unverified
      await _auth.signOut();

      Navigator.pushNamed(context, RouteNames.signinScreen);
    } on FirebaseAuthException catch (e) {
      Utils.toast(e.message ?? e.code);
    } catch (e) {
      Utils.toast(e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> continueWithGoogle() async {
    setState(() => isLoading = true);

    try {
      await _googleSignIn.signOut(); // optional
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      Utils.toast("Signed in with Google: ${googleUser.email}");
      Navigator.pushNamed(context, RouteNames.signinScreen);
    } catch (e) {
      Utils.toast(e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.1),
            Text(
              "Create Your Account",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: size.height * 0.1),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                "Sign up",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(96, 75, 72, 72),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 11),
                  hintText: "Name",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.025),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: emailController,
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
            SizedBox(height: size.height * 0.025),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(96, 75, 72, 72),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 11),
                  hintText: "Mobile Number",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.025),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: passwordController,
                obscureText: show,

                // ✅ force single line layout
                minLines: 1,
                maxLines: 1,

                // ✅ helps vertical centering
                textAlignVertical: TextAlignVertical.center,

                // ✅ makes text baseline behave nicer
                style: const TextStyle(height: 1.0),

                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(96, 75, 72, 72),
                  hintText: "Password",
                  hintStyle: const TextStyle(color: Colors.white),

                  // ✅ THIS is the main fix for 40px height
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12, // 👈 not 0
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                  // ✅ make the suffix icon match the field height
                  suffixIconConstraints: const BoxConstraints(
                    minHeight: 40,
                    minWidth: 40,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      show ? Icons.visibility_off : Icons.visibility,
                      size: 18,
                    ),
                    onPressed: () => setState(() => show = !show),
                  ),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.125),
            SizedBox(
              height: 40,
              width: 180,
              child: ElevatedButton(
                onPressed: () {
                  login();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Create account',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text("OR"),
            SizedBox(height: size.height * 0.02),
            SizedBox(
              height: 40,
              width: 180,
              child: OutlinedButton(
                onPressed: () {
                  continueWithGoogle();
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Continue with gmail",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                children: [
                  TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: Colors.black),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.signinScreen);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
