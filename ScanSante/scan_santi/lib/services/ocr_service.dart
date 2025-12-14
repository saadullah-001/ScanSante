import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OCRService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  // Method to pick image and recognize text
  Future<String> scanImage(XFile imageFile) async {
    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      // Return the raw text string
      return recognizedText.text;
    } catch (e) {
      return "Error scanning image: $e";
    }
  }

  void close() {
    _textRecognizer.close();
  }
}
