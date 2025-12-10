import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'features/nutrition-analyzer/data/repositories/food_analyzer_repository.dart';
import 'features/nutrition-analyzer/presentation/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    // print('.env loaded');
  } catch (e) {
    print('.env not found');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = FoodAnalyzerRepository(
      client: http.Client(),
    );

    return MaterialApp(
      title: 'Eatalyze',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: FoodAnalyzerPage(service: repository),
    );
  }
}