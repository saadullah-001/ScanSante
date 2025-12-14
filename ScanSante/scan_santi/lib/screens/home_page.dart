import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import 'history_screen.dart'; // Ensure you have this file created
import 'home_screen.dart';
import 'profile_screen.dart'; // Ensure you have this file created

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 1;
  late PageController pageController;

  // 1. STATE: This variable holds the "Truth" for the app
  // It starts with default 'Health Conditions' (which means no filter)
  UserPreferences _userPrefs = UserPreferences();

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // 2. LOGIC: Function to update the state when User changes Dropdown
  void _updateCondition(String newCondition) {
    setState(() {
      _userPrefs.selectedCondition = newCondition;
    });
    debugPrint("Condition Updated to: ${_userPrefs.selectedCondition}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        children: [
          const History(), // Your History Screen
          // PASS DATA: Pass the prefs and the update function to HomeScreen
          HomeScreen(prefs: _userPrefs, onConditionChanged: _updateCondition),

          ProfileScreen(),
        ],
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          pageController.jumpToPage(index);
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
