import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:software_engineering_project/features/nutrition-analyzer/domain/entities/nova_result.dart';
import 'package:software_engineering_project/features/nutrition-analyzer/domain/entities/nutritional_data.dart';
import 'package:software_engineering_project/features/nutrition-analyzer/domain/services/food_analyzer_service.dart';

class FoodAnalyzerRepository implements FoodAnalyzerService {
  final http.Client client;
  final String modelApiUrl;
  final String ocrApiUrl;

  FoodAnalyzerRepository({
    required this.client,
    String? modelApiUrl,
    String? ocrApiUrl,
  })  : modelApiUrl = (modelApiUrl ??
            dotenv.env['MODEL_API'] ?? '').replaceAll(RegExp(r'/+$'), ''),
        ocrApiUrl = (ocrApiUrl ??
            dotenv.env['OCR_API'] ?? '').replaceAll(RegExp(r'/+$'), '');

  @override
  Future<NovaResult> analyzeFood(NutritionalData data) async {
    try {
      final url = '$modelApiUrl/predict';
      print('Sending to MODEL API: $url');
      print('Data: ${json.encode(data.toMap())}');

      final response = await client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data.toMap()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return NovaResult.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to analyze food: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in analyzeFood: $e');
      throw Exception('Error analyzing food: $e');
    }
  }

  @override
  Future<NutritionalData> extractFromImage(String imagePath) async {
    try {
      print('Sending to OCR API: $ocrApiUrl');
      print('Image path: $imagePath');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$ocrApiUrl/ocr'),
      );

      if (kIsWeb) {
        // For web, read bytes from blob URL
        final XFile file = XFile(imagePath);
        final bytes = await file.readAsBytes();

        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: 'upload.jpg',
          ),
        );
      } else {
        // For mobile/desktop, use file path
        request.files.add(
          await http.MultipartFile.fromPath('image', imagePath),
        );
      }

      print('Sending OCR request...');
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      print('OCR Response status: ${response.statusCode}');
      print('OCR Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        // The OCR API should return data in this format:
        // {
        //   "energy_kcal_1g": 2.5,
        //   "fat_1g": 0.1,
        //   "carbohydrates_1g": 0.5,
        //   ...
        // }
        
        return NutritionalData.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to extract data from image: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in extractFromImage: $e');
      throw Exception('Error extracting nutritional data from image: $e');
    }
  }
}