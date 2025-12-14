import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // 1. Get your FREE key from: https://console.groq.com/keys
  final String _apiKey =
      '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';

  // 2. Groq API Endpoint
  final String _url = 'https://api.groq.com/openai/v1/chat/completions';

  Future<Map<String, dynamic>> analyzeFood(
    String ocrText,
    String userCondition,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          // 3. Use Llama 3.3 70B for best accuracy with complex JSON
          "model": "llama-3.3-70b-versatile",

          "messages": [
            {
              "role": "system",
              "content":
                  '''
                You are an expert Nutritionist AI. Analyze the food label text based on the User's Health Condition.
                
                CRITICAL: Return ONLY valid JSON. No markdown.
                
                JSON SCHEMA (Strictly follow this structure for the UI):
                {
                  "product_name": "Inferred Name",
                  "health_score": (Integer 0-100),
                  "summary_verdict": "Safe" | "Moderate" | "Avoid",
                  "warnings": ["List", "of", "warnings"],
                  "nutrition": {
                    "calories": (Integer),
                    "fat": { 
                      "saturated": (Float), 
                      "unsaturated": (Float) 
                    },
                    "carbs": { 
                      "sugar": (Float), 
                      "starch": (Float), 
                      "fiber": (Float) 
                    },
                    "protein": { 
                      "animal": (Float), 
                      "plant": (Float) 
                    }
                  },
                  "ingredients_analysis": [
                    {
                      "name": "Ingredient Name",
                      "score": (0-100),
                      "status": "Safe" | "Caution",
                      "reason": "Short reason"
                    }
                  ]
                }
                
                RULES:
                1. User Condition: "$userCondition"
                2. ESTIMATE values if not explicit in text. 
                3. If 'Diabetes', penalize Sugar/Starch. 
                4. If 'Vegan', ensure 'animal' protein is 0, otherwise estimate based on ingredients (e.g. Chicken = animal).
              ''',
            },
            {"role": "user", "content": "Analyze this text: $ocrText"},
          ],

          "response_format": {"type": "json_object"},
          "temperature": 0.1,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String contentString = data['choices'][0]['message']['content'];
        return jsonDecode(contentString);
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to analyze food: $e');
    }
  }
}
