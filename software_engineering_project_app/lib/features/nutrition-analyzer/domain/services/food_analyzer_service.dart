import 'package:software_engineering_project/features/nutrition-analyzer/domain/entities/nova_result.dart';
import 'package:software_engineering_project/features/nutrition-analyzer/domain/entities/nutritional_data.dart';

abstract class FoodAnalyzerService {
  Future<NovaResult> analyzeFood(NutritionalData data);
  Future<NutritionalData> extractFromImage(String imagePath);
}