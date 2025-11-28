class NutritionalData {
  final double energyKcal;
  final double fat;
  final double carbohydrates;
  final double protein;
  final double saturatedFat;
  final double transFat;
  final double sugars;
  final double addedSugars;
  final double sodium;
  final double salt;
  final double fiber;

  NutritionalData({
    required this.energyKcal,
    required this.fat,
    required this.carbohydrates,
    required this.protein,
    required this.saturatedFat,
    required this.transFat,
    required this.sugars,
    required this.addedSugars,
    required this.sodium,
    required this.salt,
    required this.fiber,
  });

  Map<String, double> toMap() {
    return {
      'energy_kcal_1g': energyKcal,
      'fat_1g': fat,
      'carbohydrates_1g': carbohydrates,
      'proteins_1g': protein,
      'saturated_fat_1g': saturatedFat,
      'trans_fat_1g': transFat,
      'sugars_1g': sugars,
      'added_sugars_1g': addedSugars,
      'sodium_1g': sodium,
      'salt_1g': salt,
      'fiber_1g': fiber,
    };
  }

  factory NutritionalData.fromJson(Map<String, dynamic> json) {
    return NutritionalData(
      energyKcal: (json['energy_kcal_1g'] ?? 0).toDouble(),
      fat: (json['fat_1g'] ?? 0).toDouble(),
      carbohydrates: (json['carbohydrates_1g'] ?? 0).toDouble(),
      protein: (json['proteins_1g'] ?? json['protein_1g'] ?? 0).toDouble(),
      saturatedFat: (json['saturated_fat_1g'] ?? 0).toDouble(),
      transFat: (json['trans_fat_1g'] ?? 0).toDouble(),
      sugars: (json['sugars_1g'] ?? 0).toDouble(),
      addedSugars: (json['added_sugars_1g'] ?? 0).toDouble(),
      sodium: (json['sodium_1g'] ?? 0).toDouble(),
      salt: (json['salt_1g'] ?? 0).toDouble(),
      fiber: (json['fiber_1g'] ?? 0).toDouble(),
    );
  }
}