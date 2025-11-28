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
    return NutritionalData(
      servingSizeG: (json['serving_size'] ?? 0).toDouble(),
      energyKcal: (json['energy_kcal_1g'] ?? 0).toDouble(),
      totalFatG: (json['fat_1g'] ?? 0).toDouble(),
      carbohydratesG: (json['carbohydrates_1g'] ?? 0).toDouble(),
      proteinG: (json['proteins_1g'] ?? json['protein_1g'] ?? 0).toDouble(),
      saturatedFatG: (json['saturated_fat_1g'] ?? 0).toDouble(),
      transFatG: (json['trans_fat_1g'] ?? 0).toDouble(),
      sugarsG: (json['sugars_1g'] ?? 0).toDouble(),
      addedSugarsG: (json['added_sugars_1g'] ?? 0).toDouble(),
      sodiumMg: (json['sodium_1g'] ?? 0).toDouble(),
      saltG: (json['salt_1g'] ?? 0).toDouble(),
      fiberG: (json['fiber_1g'] ?? 0).toDouble(),
    );
  }
}