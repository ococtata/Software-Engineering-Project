class NutritionalData {
  final double servingSizeG;
  final double energyKcal;
  final double totalFatG;
  final double carbohydratesG;
  final double proteinG;
  final double saturatedFatG;
  final double transFatG;
  final double sugarsG;
  final double addedSugarsG;
  final double sodiumMg;
  final double saltG;
  final double fiberG;

  NutritionalData({
    required this.servingSizeG,
    required this.energyKcal,
    required this.totalFatG,
    required this.carbohydratesG,
    required this.proteinG,
    required this.saturatedFatG,
    required this.transFatG,
    required this.sugarsG,
    required this.addedSugarsG,
    required this.sodiumMg,
    required this.saltG,
    required this.fiberG,
  });

  Map<String, double> toMap() {
    return {
      'energy_kcal_1g': energyKcal / servingSizeG,
      'fat_1g': totalFatG / servingSizeG,
      'carbohydrates_1g': carbohydratesG / servingSizeG,
      'proteins_1g': proteinG / servingSizeG,
      'saturated_fat_1g': saturatedFatG / servingSizeG,
      'trans_fat_1g': transFatG / servingSizeG,
      'sugars_1g': sugarsG / servingSizeG,
      'added_sugars_1g': addedSugarsG / servingSizeG,
      'sodium_1g': (sodiumMg / 1000) / servingSizeG,
      'salt_1g': saltG / servingSizeG,
      'fiber_1g': fiberG / servingSizeG,
    };
  }

  factory NutritionalData.fromJson(Map<String, dynamic> json) {
    // print('Received JSON: $json');
    return NutritionalData(
      servingSizeG: _parseDouble(json['serving-size']),
      energyKcal: _parseDouble(json['energy-kcal']),
      totalFatG: _parseDouble(json['fat']),
      carbohydratesG: _parseDouble(json['carbohydrates']),
      proteinG: _parseDouble(json['proteins']),
      saturatedFatG: _parseDouble(json['saturated-fat']),
      transFatG: _parseDouble(json['trans-fat']),
      sugarsG: _parseDouble(json['sugars']),
      addedSugarsG: _parseDouble(json['added-sugars']),
      sodiumMg: _parseDouble(json['sodium']),
      saltG: _parseDouble(json['salt']),
      fiberG: _parseDouble(json['fiber']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}