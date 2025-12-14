import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // 1. IMPORT SHIMMER
import 'package:scan_santi/routes_and_navigation/route_names.dart';
import 'package:scan_santi/services/database_service.dart';
import 'package:scan_santi/utilities/asset_manager.dart';
import 'package:scan_santi/utilities/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _dbService = DatabaseService();

  String _userName = "User";
  String _mobile = "Not set";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (!mounted) return;

    // Optional: Add a small delay to see the shimmer effect clearly
    // await Future.delayed(const Duration(milliseconds: 800));

    final user = _auth.currentUser;
    if (user != null) {
      if (mounted) {
        setState(() {
          _userName = user.displayName ?? "No Name";
        });
      }

      final profileData = await _dbService.getUserProfile();

      if (!mounted) return;

      if (profileData != null) {
        setState(() {
          if (profileData['name'] != null) _userName = profileData['name'];
          if (profileData['mobile'] != null) _mobile = profileData['mobile'];
        });
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  // Generic Edit Dialog (Kept as is)
  void _showEditDialog(
    String title,
    String currentValue,
    Function(String) onSave,
  ) {
    TextEditingController controller = TextEditingController(
      text: currentValue,
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: "Enter new $title",
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _changePassword() async {
    final user = _auth.currentUser;
    if (user?.email != null) {
      try {
        await _auth.sendPasswordResetEmail(email: user!.email!);
        Utils.toast("Password reset link sent to ${user.email}");
      } catch (e) {
        Utils.toast("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = _auth.currentUser;
    final String email = user?.email ?? "No Email";

    return Scaffold(
      body: _isLoading
          ? _buildShimmerLoading(size) // 2. USE SHIMMER HERE
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.1),

                    // Header
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.05),

                    // Profile Pic
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: size.height * 0.06,
                      backgroundImage: AssetImage(AssetManager.profile),
                    ),

                    SizedBox(height: size.height * 0.01),

                    // Name & Email Display
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 243, 183, 4),
                      ),
                    ),
                    Text(email, style: const TextStyle(color: Colors.grey)),

                    SizedBox(height: size.height * 0.05),

                    // 1. EDIT NAME
                    InkWell(
                      onTap: () {
                        _showEditDialog("Name", _userName, (newValue) async {
                          if (newValue.isNotEmpty) {
                            await _dbService.updateUserProfile(name: newValue);
                            _fetchUserData();
                          }
                        });
                      },
                      child: myContainer(
                        const Icon(Icons.edit),
                        "Name",
                        context,
                        false,
                      ),
                    ),

                    // 2. EDIT MOBILE
                    InkWell(
                      onTap: () {
                        _showEditDialog("Mobile Number", _mobile, (
                          newValue,
                        ) async {
                          if (newValue.isNotEmpty) {
                            await _dbService.updateUserProfile(
                              mobile: newValue,
                            );
                            _fetchUserData();
                          }
                        });
                      },
                      child: myContainer(
                        const Icon(Icons.call),
                        "Mobile: $_mobile",
                        context,
                        false,
                      ),
                    ),

                    // 3. CHANGE PASSWORD
                    InkWell(
                      onTap: _changePassword,
                      child: myContainer(
                        const Icon(Icons.lock),
                        "Change Password",
                        context,
                        false,
                      ),
                    ),

                    // 4. HELP
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: const Text("Help & Support"),
                            content: const Text(
                              "For any queries, contact support@scansante.com",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(c),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: myContainer(
                        const Icon(Icons.help),
                        "Help",
                        context,
                        false,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 5. LOGOUT
                    InkWell(
                      onTap: () {
                        _auth
                            .signOut()
                            .then((value) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RouteNames.signinScreen,
                                (route) => false,
                              );
                            })
                            .onError((error, stackTrace) {
                              Utils.toast(error.toString());
                            });
                      },
                      child: myContainer(
                        const Icon(Icons.logout, color: Colors.amber),
                        "Logout",
                        context,
                        true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // 3. CREATE SHIMMER WIDGET
  Widget _buildShimmerLoading(Size size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.1),
            // Fake Header
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),

            // Fake Avatar
            Container(
              width: size.height * 0.12,
              height: size.height * 0.12,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: size.height * 0.02),

            // Fake Name
            Container(
              width: 150,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            // Fake Email
            Container(
              width: 200,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            SizedBox(height: size.height * 0.05),

            // Fake List Items (Generate 5 rows)
            for (int i = 0; i < 5; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    // Fake Icon
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Fake Text
                    Expanded(
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
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

// Helper Widget
Widget myContainer(
  Icon icon,
  String title,
  BuildContext context,
  bool isYellow,
) {
  final size = MediaQuery.of(context).size;
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    height: size.height * 0.05,
    child: Row(
      children: [
        icon,
        SizedBox(width: size.width * 0.03),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: isYellow ? Colors.amber : Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (!isYellow)
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ],
    ),
  );
}
