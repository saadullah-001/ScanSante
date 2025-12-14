import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:scan_santi/models/food_analysis_model.dart';
import 'package:scan_santi/utilities/utils.dart';

class ComparisonScreen extends StatelessWidget {
  final FoodAnalysisModel product1;
  final FoodAnalysisModel product2;
  MaterialColor get screenColor => Utils.color(product2);

  const ComparisonScreen({
    super.key,
    required this.product1,
    required this.product2,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Compare Products"),
        backgroundColor: const Color(0xFF2E7D32), // Dark Green
        elevation: 0,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT PRODUCT
          Expanded(child: _buildProductColumn(product1)),
          // DIVIDER LINE
          Container(width: 1, color: Colors.grey[300]),
          // RIGHT PRODUCT
          Expanded(child: _buildProductColumn(product2)),
        ],
      ),
    );
  }

  Widget _buildProductColumn(FoodAnalysisModel item) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. GREEN HEADER BOX (Name + Score)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 5),
            color: screenColor,
            child: Column(
              children: [
                Text(
                  item.productName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${item.healthScore}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. Nutrition Text
          const Text(
            "Nutrition",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Calories : ${item.macros['calories']}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 20),

          // 3. BIG DONUT CHART
          SizedBox(
            height: 140,
            width: 140,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 50, // Makes it a ring
                sections: [
                  // The Score Part (Colored)
                  PieChartSectionData(
                    color: screenColor,
                    value: item.healthScore.toDouble(),
                    title: '',
                    radius: 20,
                  ),
                  // The Empty Part (Grey)
                  PieChartSectionData(
                    color: Colors.grey[200],
                    value: (100 - item.healthScore).toDouble(),
                    title: '',
                    radius: 20,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 4. CARBS HEADER BAR
          Container(
            width: 120,
            padding: const EdgeInsets.symmetric(vertical: 6),
            color: const Color(0xFF4CAF50), // Standard Green
            child: const Text(
              "Carbs",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 5. Macro Data (Sugar/Starch)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, size: 12, color: screenColor),
              const SizedBox(width: 5),
              Text(
                "Sugar : ${item.macros['carbs']?['sugar']}g",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 6. INGREDIENTS SECTION
          const Text(
            "Ingredients",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),

          // List of Ingredient Chips
          ...item.ingredientsAnalysis.take(4).map((ing) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                // Gradient Green Box
                gradient: LinearGradient(
                  colors: [screenColor.withOpacity(0.8), screenColor],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      ing['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.white54,
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
