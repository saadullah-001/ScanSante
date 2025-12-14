import 'package:flutter/material.dart';
import 'package:scan_santi/models/food_analysis_model.dart';
import 'package:scan_santi/models/user_preferences.dart';
import 'package:scan_santi/routes_and_navigation/route_names.dart';
import 'package:scan_santi/services/database_service.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scan History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black, // Makes back button/text black
      ),
      backgroundColor: Colors.grey[50], // Light background
      body: StreamBuilder<List<FoodAnalysisModel>>(
        stream: _dbService.getUserHistory(),
        builder: (context, snapshot) {
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error State
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // 3. Empty State
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("No scans yet", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // 4. Success State (List of Scans)
          final scans = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: scans.length,
            itemBuilder: (context, index) {
              final scan = scans[index];
              final bool isHealthy = scan.healthScore > 60;
              final Color scoreColor = isHealthy ? Colors.green : Colors.orange;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  // A. Score Circle (Leading)
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: scoreColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: scoreColor, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        "${scan.healthScore}",
                        style: TextStyle(
                          color: scoreColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  // B. Product Info
                  title: Text(
                    scan.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("Verdict: ${scan.verdict}"),
                      Text(
                        "${scan.macros['calories']} kcal",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),

                  // C. Navigation Arrow
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),

                  // D. Tap to Open Result
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.resultScreen,
                      arguments: {
                        'model': scan,
                        // Provide default prefs since this is history
                        'userPrefs': UserPreferences(),
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
