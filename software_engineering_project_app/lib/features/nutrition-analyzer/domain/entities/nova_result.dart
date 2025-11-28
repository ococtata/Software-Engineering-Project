class NovaResult {
  final int novaGroup;
  final String label;
  final String description;
  final double confidence;

  NovaResult({
    required this.novaGroup,
    required this.label,
    required this.description,
    required this.confidence,
  });

  static String getLabelForGroup(int group) {
    switch (group) {
      case 1:
        return 'Unprocessed';
      case 2:
        return 'Processed Culinary';
      case 3:
        return 'Processed';
      case 4:
        return 'Ultra-Processed';
      default:
        return 'Unknown';
    }
  }

  static String getDescriptionForGroup(int group) {
    switch (group) {
      case 1:
        return 'Unprocessed or minimally processed foods';
      case 2:
        return 'Processed culinary ingredients';
      case 3:
        return 'Processed foods';
      case 4:
        return 'Ultra-processed food and drink products';
      default:
        return 'Unknown classification';
    }
  }

  factory NovaResult.fromJson(Map<String, dynamic> json) {
    final group = json['nova_group'] as int;
    return NovaResult(
      novaGroup: group,
      label: getLabelForGroup(group),
      description: getDescriptionForGroup(group),
      confidence: (json['confidence'] ?? 1.0).toDouble(),
    );
  }
}