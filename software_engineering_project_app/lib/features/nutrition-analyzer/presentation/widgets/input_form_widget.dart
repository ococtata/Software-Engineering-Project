import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/nutritional_data.dart';

class InputFormWidget extends StatefulWidget {
  final Function(NutritionalData) onAnalyze;
  final Function(String) onExtractFromImage;
  final VoidCallback onReset;
  final bool isLoading;
  final NutritionalData? extractedData;

  const InputFormWidget({
    super.key,
    required this.onAnalyze,
    required this.onExtractFromImage,
    required this.onReset,
    required this.isLoading,
    this.extractedData,
  });

  @override
  State<InputFormWidget> createState() => _InputFormWidgetState();
}

class _InputFormWidgetState extends State<InputFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  String? _selectedFileName;

  final Map<String, TextEditingController> _controllers = {
    'energy': TextEditingController(),
    'fat': TextEditingController(),
    'carbs': TextEditingController(),
    'protein': TextEditingController(),
    'satFat': TextEditingController(),
    'transFat': TextEditingController(),
    'sugars': TextEditingController(),
    'addedSugars': TextEditingController(),
    'sodium': TextEditingController(),
    'salt': TextEditingController(),
    'fiber': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _populateFromExtractedData();
  }

  @override
  void didUpdateWidget(InputFormWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.extractedData != oldWidget.extractedData) {
      _populateFromExtractedData();
    }
  }

  void _populateFromExtractedData() {
    if (widget.extractedData != null) {
      final data = widget.extractedData!;
      _controllers['energy']!.text = data.energyKcal.toString();
      _controllers['fat']!.text = data.fat.toString();
      _controllers['carbs']!.text = data.carbohydrates.toString();
      _controllers['protein']!.text = data.protein.toString();
      _controllers['satFat']!.text = data.saturatedFat.toString();
      _controllers['transFat']!.text = data.transFat.toString();
      _controllers['sugars']!.text = data.sugars.toString();
      _controllers['addedSugars']!.text = data.addedSugars.toString();
      _controllers['sodium']!.text = data.sodium.toString();
      _controllers['salt']!.text = data.salt.toString();
      _controllers['fiber']!.text = data.fiber.toString();
    }
  }

  @override
  void dispose() {
    _controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedFileName = image.name;
        });

        // For web, we use the path directly
        // For mobile, the path is the file path
        widget.onExtractFromImage(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleAnalyze() {
    if (_formKey.currentState!.validate()) {
      final data = NutritionalData(
        energyKcal: double.parse(_controllers['energy']!.text),
        fat: double.parse(_controllers['fat']!.text),
        carbohydrates: double.parse(_controllers['carbs']!.text),
        protein: double.parse(_controllers['protein']!.text),
        saturatedFat: double.parse(_controllers['satFat']!.text),
        transFat: double.parse(_controllers['transFat']!.text),
        sugars: double.parse(_controllers['sugars']!.text),
        addedSugars: double.parse(_controllers['addedSugars']!.text),
        sodium: double.parse(_controllers['sodium']!.text),
        salt: double.parse(_controllers['salt']!.text),
        fiber: double.parse(_controllers['fiber']!.text),
      );
      widget.onAnalyze(data);
    }
  }

  void _handleReset() {
    _controllers.values.forEach((c) => c.clear());
    _formKey.currentState?.reset();
    setState(() {
      _selectedFileName = null;
    });
    widget.onReset();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Nutritional Information',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter values per 1g of product',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),

            // Input fields
            _buildTextField('energy', 'Energy (kcal/g)', Icons.flash_on),
            _buildTextField('fat', 'Fat (g)', Icons.water_drop),
            _buildTextField('carbs', 'Carbohydrates (g)', Icons.grain),
            _buildTextField('protein', 'Protein (g)', Icons.egg),
            _buildTextField(
                'satFat', 'Saturated Fat (g)', Icons.water_drop_outlined),
            _buildTextField('transFat', 'Trans Fat (g)', Icons.dangerous),
            _buildTextField('sugars', 'Sugars (g)', Icons.cake),
            _buildTextField(
                'addedSugars', 'Added Sugars (g)', Icons.add_circle_outline),
            _buildTextField('sodium', 'Sodium (g)', Icons.circle_outlined),
            _buildTextField('salt', 'Salt (g)', Icons.circle),
            _buildTextField('fiber', 'Fiber (g)', Icons.spa),

            const SizedBox(height: 24),

            // Image upload
            Card(
              elevation: 2,
              child: InkWell(
                onTap: widget.isLoading ? null : _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.isLoading
                          ? Colors.grey.shade300
                          : Theme.of(context).colorScheme.primary,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _selectedFileName != null
                            ? Icons.check_circle
                            : Icons.add_photo_alternate,
                        size: 48,
                        color: _selectedFileName != null
                            ? Colors.green
                            : (widget.isLoading
                                ? Colors.grey
                                : Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _selectedFileName != null
                            ? 'Image Selected'
                            : 'Upload Image for OCR',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: widget.isLoading ? Colors.grey : null,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedFileName ?? 'Extract nutritional data from label',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                        textAlign: TextAlign.center,
                      ),
                      if (_selectedFileName != null) ...[
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedFileName = null;
                            });
                          },
                          icon: const Icon(Icons.close, size: 16),
                          label: const Text('Remove'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.isLoading ? null : _handleReset,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: widget.isLoading ? null : _handleAnalyze,
                    icon: widget.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.analytics),
                    label: Text(widget.isLoading ? 'Analyzing...' : 'Analyze'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String key, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          filled: true,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required';
          if (double.tryParse(value) == null) return 'Invalid number';
          return null;
        },
      ),
    );
  }
}