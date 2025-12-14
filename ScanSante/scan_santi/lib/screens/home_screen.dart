import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import '../routes_and_navigation/route_names.dart'; // Import this instead of scan_screen.dart

class HomeScreen extends StatelessWidget {
  final UserPreferences prefs;
  final Function(String) onConditionChanged;

  const HomeScreen({
    super.key,
    required this.prefs,
    required this.onConditionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.2),
              const Text(
                "ScanSante",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: size.height * 0.14),

              // 2. The Dropdown
              SizedBox(
                height: 60,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Health Condition',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  isExpanded: true,
                  items:
                      [
                        'Normal',
                        'High blood protection',
                        'Low blood protection',
                        'Diabetes',
                        'Hypertension',
                        'Vegan',
                        'Nut Allergy',
                        'Gluten Intolerance',
                        'Lactose Intolerance',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      onConditionChanged(newValue);
                    }
                  },
                ),
              ),

              SizedBox(height: size.height * 0.2),

              // 3. The Scan Button (UPDATED)
              SizedBox(
                height: 50,
                width: 180,
                child: ElevatedButton(
                  onPressed: () {
                    // NEW: Use pushNamed and pass 'prefs' as arguments
                    Navigator.pushNamed(
                      context,
                      RouteNames.scanScreen,
                      arguments:
                          prefs, // This matches the 'args' in routes.dart
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Tap to scan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
