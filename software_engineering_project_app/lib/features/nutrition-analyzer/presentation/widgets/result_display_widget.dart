import 'package:flutter/material.dart';
import '../../domain/entities/nova_result.dart';

class ResultDisplayWidget extends StatelessWidget {
  final NovaResult? result;
  final String? error;
  final bool isLoading;

  const ResultDisplayWidget({
    super.key,
    this.result,
    this.error,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Analysis Result',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),

          if (isLoading)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Analyzing nutritional data...'),
                  ],
                ),
              ),
            )
          else if (error != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 80, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(error!, textAlign: TextAlign.center),
                  ],
                ),
              ),
            )
          else if (result == null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.analytics_outlined,
                        size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('No analysis yet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[600],
                            )),
                    const SizedBox(height: 8),
                    Text('Fill in the data and click Analyze',
                        style: TextStyle(color: Colors.grey[500])),
                  ],
                ),
              ),
            )
          else
            Expanded(child: _buildResultCard(context, result!)),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, NovaResult result) {
    final color = _getColorForGroup(result.novaGroup);

    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            elevation: 4,
            color: color,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(_getIconForGroup(result.novaGroup),
                      size: 80, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    'NOVA Group ${result.novaGroup}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.label,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    result.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildNovaInfoCard(context, result.novaGroup),
        ],
      ),
    );
  }

  Widget _buildNovaInfoCard(BuildContext context, int selectedGroup) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NOVA Classification System',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildNovaInfoItem(1, 'Unprocessed',
                'Fresh foods with no processing', selectedGroup),
            _buildNovaInfoItem(2, 'Processed Culinary',
                'Processed ingredients for cooking', selectedGroup),
            _buildNovaInfoItem(3, 'Processed',
                'Foods with added ingredients', selectedGroup),
            _buildNovaInfoItem(
                4, 'Ultra-Processed', 
                'Industrial formulations', selectedGroup),
          ],
        ),
      ),
    );
  }

  Widget _buildNovaInfoItem(
      int group, String label, String description, int selectedGroup) {
    final isSelected = group == selectedGroup;
    final color = _getColorForGroup(group);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.1) : null,
        border: Border.all(
          color: isSelected ? color : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                group.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isSelected ? color : null,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForGroup(int group) {
    switch (group) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow.shade700;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForGroup(int group) {
    switch (group) {
      case 1:
        return Icons.eco;
      case 2:
        return Icons.kitchen;
      case 3:
        return Icons.restaurant;
      case 4:
        return Icons.fastfood;
      default:
        return Icons.help_outline;
    }
  }
}