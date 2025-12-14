import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:scan_santi/models/food_analysis_model.dart';
import 'package:scan_santi/models/user_preferences.dart';
import 'package:scan_santi/routes_and_navigation/route_names.dart';
import 'package:scan_santi/utilities/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io'; // Needed for File
import 'dart:typed_data'; // Needed for Uint8List
import 'package:path_provider/path_provider.dart'; // To get temp path
import 'package:screenshot/screenshot.dart';

class ResultScreen extends StatefulWidget {
  final FoodAnalysisModel model;
  final UserPreferences userPrefs;

  const ResultScreen({super.key, required this.model, required this.userPrefs});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // 1. Controller and State Variables
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSharing = false;
  MaterialColor get screenColor => Utils.color(widget.model);

  // 2. Share Function
  Future<void> shareResult() async {
    setState(() => _isSharing = true);

    try {
      // A. Capture the widget as an image
      // Note: This requires the Screenshot widget in the build method below
      final Uint8List? imageBytes = await _screenshotController.capture();

      if (imageBytes != null) {
        // B. Get temp directory
        final directory = await getTemporaryDirectory();
        final imagePath = await File(
          '${directory.path}/scan_result.png',
        ).create();

        // C. Write bytes
        await imagePath.writeAsBytes(imageBytes);

        // D. Create message
        final String message =
            "Look at this food analysis! ${widget.model.productName} has a score of ${widget.model.healthScore}/100 on ScanSanté.";

        // E. Share
        // ignore: deprecated_member_use
        await Share.shareXFiles([XFile(imagePath.path)], text: message);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error sharing: $e")));
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: screenColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          widget.model.healthScore.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          // Top Share Button (Optional, can point to same function)
          IconButton(
            icon: _isSharing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.share, color: Colors.white),
            onPressed: _isSharing ? null : shareResult,
          ),
        ],
      ),

      // 3. WRAP BODY IN SCREENSHOT WIDGET
      // This is essential for the capture() function to work
      body: Screenshot(
        controller: _screenshotController,
        child: Container(
          color: Colors
              .white, // Ensure background is captured as white, not transparent
          child: SingleChildScrollView(
            child: Column(
              children: [
                // --- HEADER SECTION ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: screenColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.model.productName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- NUTRITION & CALORIES ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Nutrition",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Calories: ${widget.model.macros['calories']}",
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // --- PIE CHART SECTION ---
                SizedBox(
                  height: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 60,
                          sections: [
                            // Carbs (Green)
                            PieChartSectionData(
                              color: const Color(0xFF4CAF50),
                              value:
                                  (widget.model.macros['carbs']?['sugar'] ??
                                      10) +
                                  (widget.model.macros['carbs']?['starch'] ??
                                      10),
                              title: '',
                              radius: 50,
                            ),
                            // Protein (Red)
                            PieChartSectionData(
                              color: const Color(0xFFF44336),
                              value:
                                  (widget.model.macros['protein']?['animal'] ??
                                      10) +
                                  (widget.model.macros['protein']?['plant'] ??
                                      10),
                              title: '',
                              radius: 50,
                            ),
                            // Fat (Yellow)
                            PieChartSectionData(
                              color: const Color(0xFFFFEB3B),
                              value:
                                  (widget.model.macros['fat']?['saturated'] ??
                                      10) +
                                  (widget.model.macros['fat']?['unsaturated'] ??
                                      10),
                              title: '',
                              radius: 50,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- MACROS ROW ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMacroColumn(
                        title: "Fat",
                        color: const Color(0xFFFFF176),
                        textColor: Colors.black,
                        items: [
                          "Sat: ${widget.model.macros['fat']?['saturated']}g",
                          "Unsat: ${widget.model.macros['fat']?['unsaturated']}g",
                        ],
                        dotColor: Colors.orange,
                      ),
                      _buildMacroColumn(
                        title: "Carbs",
                        color: const Color(0xFF66BB6A),
                        textColor: Colors.white,
                        items: [
                          "Sugar: ${widget.model.macros['carbs']?['sugar']}g",
                          "Starch: ${widget.model.macros['carbs']?['starch']}g",
                          "Fiber: ${widget.model.macros['carbs']?['fiber']}g",
                        ],
                        dotColor: Colors.green[900]!,
                      ),
                      _buildMacroColumn(
                        title: "Proteins",
                        color: const Color(0xFFEF5350),
                        textColor: Colors.white,
                        items: [
                          "Animal: ${widget.model.macros['protein']?['animal']}g",
                          "Plant: ${widget.model.macros['protein']?['plant']}g",
                        ],
                        dotColor: Colors.red[900]!,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // --- INGREDIENTS LIST ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Ingredients :",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: widget.model.ingredientsAnalysis.length,
                  itemBuilder: (context, index) {
                    final ingredient = widget.model.ingredientsAnalysis[index];
                    final double score = (ingredient['score'] as num)
                        .toDouble();
                    final bool isSafe = score > 80;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isSafe
                              ? [
                                  const Color(0xFF43A047),
                                  const Color(0xFF66BB6A),
                                ]
                              : [
                                  const Color(0xFFD32F2F),
                                  const Color(0xFFEF5350),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        leading: const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 30,
                        ),
                        title: Text(
                          ingredient['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          "Score: $score",
                          style: const TextStyle(color: Colors.black87),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),

      // Bottom Bar
      bottomNavigationBar: Container(
        height: 60,
        color: screenColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.scanScreen,
                  arguments: {
                    'userPrefs': widget.userPrefs,
                    'firstProduct': widget.model,
                  },
                );
              },
              icon: const Icon(Icons.compare_arrows, color: Colors.white),
              label: const Text(
                "Compare",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.scanScreen,
                  arguments: widget.userPrefs,
                );
              },
              icon: const Icon(
                Icons.search,
                size: 40,
                color: Colors.white,
              ), // Fixed icon color
            ),

            TextButton.icon(
              onPressed: _isSharing ? null : shareResult,
              icon: _isSharing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.share, color: Colors.white),
              label: Text(
                _isSharing ? "Saving..." : "Share",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget
  Widget _buildMacroColumn({
    required String title,
    required Color color,
    required Color textColor,
    required List<String> items,
    required Color dotColor,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: color,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: dotColor, size: 12),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
