import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scan_santi/routes_and_navigation/route_names.dart';
import 'package:scan_santi/utilities/utils.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isLoading = false;
  bool show = false;

  void login() async {
    setState(() => isLoading = true);

    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim().toLowerCase(),
        password: _passwordController.text.trim(),
      );

      // Refresh user state from server
      await cred.user!.reload();
      final user = _auth.currentUser;

      if (user == null) {
        Utils.toast("Login failed. Try again.");
        return;
      }

      if (!user.emailVerified) {
        // Optionally resend verification
        await user.sendEmailVerification();

        await _auth.signOut();
        Utils.toast("Email not verified. We sent the link again.");
        return;
      }

      Utils.toast("Logged in successfully");
      Navigator.pushNamed(context, RouteNames.homePage);
    } on FirebaseAuthException catch (e) {
      Utils.toast(e.message ?? e.code);
    } catch (e) {
      Utils.toast(e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void continueWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);

      Utils.toast("Signed in with Google: ${googleUser.email}");
      Navigator.pushNamed(context, RouteNames.homePage);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Utils.toast(e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
              "Welcome To",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              "ScanSante",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 38,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: size.height * 0.1),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                "Signin",
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
            SizedBox(height: size.height * 0.025),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: _passwordController,
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
            SizedBox(height: size.height * 0.02),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.forgotPassword);
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.1),
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

                child: isLoading == true
                    ? CircularProgressIndicator()
                    : Text(
                        'Signin',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
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
                  "Sign in with google",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: "No Account ? ",
                    style: TextStyle(color: Colors.black),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.signupScreen);
                      },
                      child: Text(
                        "Create One",
                        style: TextStyle(color: Colors.amber),
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
