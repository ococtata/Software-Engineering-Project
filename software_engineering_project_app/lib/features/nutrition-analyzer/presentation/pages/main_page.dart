import 'package:flutter/material.dart';
import '../../domain/entities/nutritional_data.dart';
import '../../domain/entities/nova_result.dart';
import '../../domain/services/food_analyzer_service.dart';
import '../widgets/input_form_widget.dart';
import '../widgets/result_display_widget.dart';

class FoodAnalyzerPage extends StatefulWidget {
  final FoodAnalyzerService service;

  const FoodAnalyzerPage({super.key, required this.service});

  @override
  State<FoodAnalyzerPage> createState() => _FoodAnalyzerPageState();
}

class _FoodAnalyzerPageState extends State<FoodAnalyzerPage> {
  NovaResult? _result;
  bool _isLoading = false;
  String? _error;
  NutritionalData? _extractedData;

  /// Called when user clicks "Analyze" button
  /// Uses MODEL API to predict NOVA group from nutritional data
  Future<void> _analyzeFood(NutritionalData data) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      print('📊 Analyzing food with MODEL API...');
      final result = await widget.service.analyzeFood(data);
      setState(() {
        _result = result;
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analysis complete! NOVA Group: ${result.novaGroup}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error analyzing: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Called when user uploads an image
  /// Uses OCR API to extract nutritional data and auto-fill inputs
  Future<void> _extractFromImage(String imagePath) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('🖼️ Extracting nutritional data from image using OCR API...');
      final data = await widget.service.extractFromImage(imagePath);
      
      setState(() {
        _extractedData = data;
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Data extracted! Fields have been auto-filled.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ OCR Error: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _resetAnalysis() {
    setState(() {
      _result = null;
      _error = null;
      _extractedData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eatalyze - Food Processing Analyzer'),
        centerTitle: true,
        elevation: 2,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;

          if (isWide) {
            return Row(
              children: [
                Expanded(
                  child: InputFormWidget(
                    onAnalyze: _analyzeFood,
                    onExtractFromImage: _extractFromImage,
                    onReset: _resetAnalysis,
                    isLoading: _isLoading,
                    extractedData: _extractedData,
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: ResultDisplayWidget(
                    result: _result,
                    error: _error,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  InputFormWidget(
                    onAnalyze: _analyzeFood,
                    onExtractFromImage: _extractFromImage,
                    onReset: _resetAnalysis,
                    isLoading: _isLoading,
                    extractedData: _extractedData,
                  ),
                  const Divider(height: 1),
                  SizedBox(
                    height: 600,
                    child: ResultDisplayWidget(
                      result: _result,
                      error: _error,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}