class FoodAnalysisModel {
  final String productName;
  final int healthScore;
  final String verdict;
  final List<String> warnings;
  final Map<String, dynamic> macros;
  final List<dynamic> ingredientsAnalysis;

  FoodAnalysisModel({
    required this.productName,
    required this.healthScore,
    required this.verdict,
    required this.warnings,
    required this.macros,
    required this.ingredientsAnalysis,
  });

  factory FoodAnalysisModel.fromJson(Map<String, dynamic> json) {
    // 1. Safety Check: Ensure 'nutrition' exists, otherwise use empty map
    Map<String, dynamic> rawNutrition = json['nutrition'] ?? {};

    // 2. Helper to ensure we never get NULL values in our UI
    // If the AI forgets 'fat', we create a map with 0.0 defaults
    Map<String, dynamic> safeMacros = {
      'calories': rawNutrition['calories'] ?? 0,
      'fat': {
        'saturated': _toDouble(rawNutrition['fat']?['saturated']),
        'unsaturated': _toDouble(rawNutrition['fat']?['unsaturated']),
      },
      'carbs': {
        'sugar': _toDouble(rawNutrition['carbs']?['sugar']),
        'starch': _toDouble(rawNutrition['carbs']?['starch']),
        'fiber': _toDouble(rawNutrition['carbs']?['fiber']),
      },
      'protein': {
        'animal': _toDouble(rawNutrition['protein']?['animal']),
        'plant': _toDouble(rawNutrition['protein']?['plant']),
      },
    };

    return FoodAnalysisModel(
      productName: json['product_name'] ?? 'Scanned Food',
      healthScore: json['health_score'] ?? 0,
      verdict: json['summary_verdict'] ?? 'Unknown',
      // Ensure warnings is a List of Strings
      warnings: List<String>.from(json['warnings'] ?? []),
      macros: safeMacros,
      ingredientsAnalysis: json['ingredients_analysis'] ?? [],
    );
  }

  // Helper to convert any number (int/double/String) to double safely
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'health_score': healthScore,
      'summary_verdict': verdict,
      'warnings': warnings,
      'nutrition': macros,
      'ingredients_analysis': ingredientsAnalysis,
      // We don't save 'timestamp' here, we add it in the service
    };
  }
}
