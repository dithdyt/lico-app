import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_provider.dart';
import 'crossroads_screen.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _monthsController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(calculatorNotifierProvider);
    final notifier = ref.read(calculatorNotifierProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("REALITY CHECK")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "APA YANG INGIN ANDA BELI?",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.black,
              ),
            ),
            const SizedBox(height: 32),

            _buildLabel("NAMA BARANG"),
            _buildTextField(
              controller: _nameController,
              hint: "Misal: MacBook Pro M3",
              onChanged: notifier.updateItemName,
            ),

            const SizedBox(height: 24),

            _buildLabel("HARGA BARANG (RP)"),
            _buildTextField(
              controller: _priceController,
              hint: "0",
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (val) =>
                  notifier.updateItemPrice(double.tryParse(val) ?? 0),
            ),

            const SizedBox(height: 32),

            // Paylater Toggle
            _buildToggle(
              label: "GUNAKAN PAYLATER / CICILAN?",
              value: state.isPaylater,
              onChanged: notifier.togglePaylater,
            ),

            if (state.isPaylater) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("TENOR (BULAN)"),
                        _buildTextField(
                          controller: _monthsController,
                          hint: "12",
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (val) =>
                              notifier.updateMonths(int.tryParse(val) ?? 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("BUNGA TOTAL (%)"),
                        _buildTextField(
                          controller: _interestController,
                          hint: "0",
                          keyboardType: TextInputType.number,
                          onChanged: (val) => notifier.updateInterest(
                            double.tryParse(val) ?? 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 48),

            _buildSubmitButton(
              label: "HITUNG BEBAN WAKTU",
              onPressed: () {
                if (state.itemName.isEmpty || state.itemPrice <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Isi nama dan harga barang dulu ya!"),
                    ),
                  );
                  return;
                }

                notifier.calculate();
                final newState = ref.read(calculatorNotifierProvider);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CrossroadsScreen(
                      itemName: newState.itemName,
                      itemPrice: newState.itemPrice,
                      timeCostInHours: newState.timeCostInHours,
                      isPaylater: newState.isPaylater,
                      months: newState.months,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    required Function(String) onChanged,
  }) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
      ),
    );
  }

  Widget _buildToggle({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: value ? theme.colorScheme.primary.withOpacity(0.08) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              value ? Icons.check_circle : Icons.radio_button_unchecked,
              color: value ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
