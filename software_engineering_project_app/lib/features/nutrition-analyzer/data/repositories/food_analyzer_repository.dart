import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:software_engineering_project/features/nutrition-analyzer/domain/entities/nova_result.dart';
import 'package:software_engineering_project/features/nutrition-analyzer/domain/entities/nutritional_data.dart';
import 'package:software_engineering_project/features/nutrition-analyzer/domain/services/food_analyzer_service.dart';

class FoodAnalyzerRepository implements FoodAnalyzerService {
  final http.Client client;
  final String baseUrl;

  FoodAnalyzerRepository({
    required this.client,
    String? baseUrl,
  }) : baseUrl = baseUrl ?? dotenv.env['MODEL_API'] ?? '';

  @override
  Future<NovaResult> analyzeFood(NutritionalData data) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data.toMap()),
      );

      if (response.statusCode == 200) {
        return NovaResult.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to analyze food: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error analyzing food: $e');
    }
  }

  @override
  Future<NutritionalData> extractFromImage(String imagePath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/ocr'));

      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        return NutritionalData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to extract data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error extracting data: $e');
    }
  }
}