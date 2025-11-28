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
    'servingSize': TextEditingController(),
    'energy': TextEditingController(),
    'totalFat': TextEditingController(),
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
      _controllers['servingSize']!.text = data.servingSizeG.toString();
      _controllers['energy']!.text = data.energyKcal.toString();
      _controllers['totalFat']!.text = data.totalFatG.toString();
      _controllers['carbs']!.text = data.carbohydratesG.toString();
      _controllers['protein']!.text = data.proteinG.toString();
      _controllers['satFat']!.text = data.saturatedFatG.toString();
      _controllers['transFat']!.text = data.transFatG.toString();
      _controllers['sugars']!.text = data.sugarsG.toString();
      _controllers['addedSugars']!.text = data.addedSugarsG.toString();
      _controllers['sodium']!.text = data.sodiumMg.toString();
      _controllers['salt']!.text = data.saltG.toString();
      _controllers['fiber']!.text = data.fiberG.toString();
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
        servingSizeG: double.parse(_controllers['servingSize']!.text),
        energyKcal: double.parse(_controllers['energy']!.text),
        totalFatG: double.parse(_controllers['totalFat']!.text),
        carbohydratesG: double.parse(_controllers['carbs']!.text),
        proteinG: double.parse(_controllers['protein']!.text),
        saturatedFatG: double.parse(_controllers['satFat']!.text),
        transFatG: double.parse(_controllers['transFat']!.text),
        sugarsG: double.parse(_controllers['sugars']!.text),
        addedSugarsG: double.parse(_controllers['addedSugars']!.text),
        sodiumMg: double.parse(_controllers['sodium']!.text),
        saltG: double.parse(_controllers['salt']!.text),
        fiberG: double.parse(_controllers['fiber']!.text),
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
              'Enter values exactly as shown on the label',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),

            Text(
              'Amount per serving',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),

            // Input fields
            _buildTextField('servingSize', 'Serving Size (g)', Icons.scale),
            _buildTextField('energy', 'Calories', Icons. flash_on),
            _buildTextField('totalFat', 'Total Fat (g)', Icons.water_drop),
            _buildTextField('satFat', 'Saturated Fat (g)', Icons.water_drop_outlined),
            _buildTextField('transFat', 'Trans Fat (g)', Icons.dangerous),
            _buildTextField('sodium', 'Sodium (mg)', Icons.circle_outlined),
            _buildTextField('carbs', 'Total Carbohydrates (g)', Icons.grain),
            _buildTextField('fiber', 'Fiber (g)', Icons.spa),
            _buildTextField('sugars', 'Sugars (g)', Icons.cake),
            _buildTextField('addedSugars', 'Added Sugars (g)', Icons.add_circle_outline),
            _buildTextField('protein', 'Protein (g)', Icons.egg),
            _buildTextField('salt', 'Salt (g)', Icons.circle),

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
                        _selectedFileName ?? 'Extract nutritional data from image',
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