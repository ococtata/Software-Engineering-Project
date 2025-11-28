class NovaResult {
  final int novaGroup;
  final String label;
  final String description;

  NovaResult({
    required this.novaGroup,
    required this.label,
    required this.description,
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
    final predictionList = json['prediction'];
    final group = (predictionList is List && predictionList.isNotEmpty)
        ? predictionList.first
              .toInt()
        : 0;

    return NovaResult(
      novaGroup: group,
      label: getLabelForGroup(group),
      description: getDescriptionForGroup(group),
    );
  }
}