import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan_santi/models/user_preferences.dart';
import 'package:scan_santi/models/food_analysis_model.dart'; // Import Model
import 'package:scan_santi/services/ai_service.dart'; // Import AI Service
import 'package:scan_santi/routes_and_navigation/route_names.dart';
import 'package:scan_santi/services/database_service.dart';
import '../services/ocr_service.dart';

class ScanScreen extends StatefulWidget {
  // CRITICAL: We need UserPreferences to tell the AI about the user's condition
  final UserPreferences userPrefs;
  final FoodAnalysisModel? firstProduct;

  const ScanScreen({super.key, required this.userPrefs, this.firstProduct});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final OCRService _ocrService = OCRService();
  final AIService _aiService = AIService(); // Initialize AI Service
  final ImagePicker _picker = ImagePicker();
  final DatabaseService _dbService = DatabaseService();

  bool _isScanning = false;
  String _loadingMessage = "Processing...";

  Future<void> _pickAndScanImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;

      setState(() {
        _isScanning = true;
        _loadingMessage = "Reading Text...";
      });

      // 1. OCR Step
      String extractedText = await _ocrService.scanImage(image);

      if (extractedText.isEmpty) {
        throw "No text found on label.";
      }

      setState(() {
        _loadingMessage = "Analyzing with AI...";
      });

      // 2. AI Step (Send Text + User Condition)
      Map<String, dynamic> aiResponse = await _aiService.analyzeFood(
        extractedText,
        widget.userPrefs.selectedCondition,
      );

      // 3. Convert JSON to Model
      FoodAnalysisModel currentScan = FoodAnalysisModel.fromJson(aiResponse);

      _dbService.saveScan(currentScan);

      if (!mounted) return;

      // CHECK FOR COMPARISON
      if (widget.firstProduct != null) {
        // Go to Comparison Screen
        Navigator.pushNamed(
          context,
          RouteNames.compareScreen,
          arguments: {'first': widget.firstProduct, 'second': currentScan},
        );
      } else {
        // Go to Result Screen
        // FIX: Pass a MAP, not just the model
        Navigator.pushNamed(
          context,
          RouteNames.resultScreen,
          arguments: {
            'model': currentScan,
            'userPrefs':
                widget.userPrefs, // Pass this so ResultScreen can use it later
          },
        );
      }
    } catch (e) {
      // If using a Utils class for toasts
      // Utils.toast(e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _ocrService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Ingredients")),
      body: Center(
        child: _isScanning
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(_loadingMessage, style: const TextStyle(fontSize: 16)),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.document_scanner,
                    size: 100,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 20),
                  const Text("Scan a food label to analyze"),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () => _pickAndScanImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Open Camera"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => _pickAndScanImage(ImageSource.gallery),
                    icon: const Icon(Icons.image),
                    label: const Text("Pick from Gallery"),
                  ),
                ],
              ),
      ),
    );
  }
}
