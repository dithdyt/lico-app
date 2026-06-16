import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lico/features/ledger/presentation/dashboard_screen.dart';
import 'package:lico/features/ledger/providers/ledger_provider.dart';
import '../providers/valuation_provider.dart';

class ValuationScreen extends ConsumerStatefulWidget {
  const ValuationScreen({super.key});

  @override
  ConsumerState<ValuationScreen> createState() => _ValuationScreenState();
}

class _ValuationScreenState extends ConsumerState<ValuationScreen> {
  final _incomeController = TextEditingController();
  final _hoursController = TextEditingController();
  String _incomeInput = '';
  String _hoursInput = '';
  bool _isLoading = false;
  bool _isStudent = false;
  bool _hasHydratedInitialValues = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_hasHydratedInitialValues) return;

      final currentValuation = ref.read(valuationNotifierProvider).value;
      if (currentValuation != null) {
        _incomeInput = currentValuation.monthlyIncome.toStringAsFixed(0);
        _hoursInput = currentValuation.dailyWorkHours.toStringAsFixed(0);
        _incomeController.text = _incomeInput;
        _hoursController.text = _hoursInput;
      }
      _hasHydratedInitialValues = true;
    });
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final income = _parseNumberInput(
      _incomeInput.isNotEmpty ? _incomeInput : _incomeController.text,
    );
    final hours = _parseNumberInput(
      _hoursInput.isNotEmpty ? _hoursInput : _hoursController.text,
    );

    if (income <= 0 || hours <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Harap masukkan nilai yang valid dan lebih besar dari 0.",
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(valuationNotifierProvider.notifier)
          .saveValuation(monthlyIncome: income, dailyWorkHours: hours);

      if (!mounted) return;

      ref.invalidate(valuationNotifierProvider);
      ref.invalidate(ledgerNotifierProvider);
      await ref.read(valuationNotifierProvider.future);

      if (!mounted) return;

      setState(() => _isLoading = false);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
        );
      }
    }
  }

  double _parseNumberInput(String rawValue) {
    var value = rawValue.trim().toLowerCase();
    if (value.isEmpty) return 0;

    final isMillion = value.contains('jt') || value.contains('juta');
    value = value
        .replaceAll('rp', '')
        .replaceAll('idr', '')
        .replaceAll('juta', '')
        .replaceAll('jt', '')
        .replaceAll(RegExp(r'\s+'), '');

    value = value.replaceAll(RegExp(r'[^0-9,.\-]'), '');
    if (value.isEmpty || value == '-' || value == ',' || value == '.') {
      return 0;
    }

    final commaCount = ','.allMatches(value).length;
    final dotCount = '.'.allMatches(value).length;
    if (commaCount > 0 && dotCount > 0) {
      value = value.replaceAll('.', '').replaceAll(',', '.');
    } else if (commaCount > 0) {
      value = _normalizeSingleSeparator(value, ',');
    } else if (dotCount > 0) {
      value = _normalizeSingleSeparator(value, '.');
    }

    final parsed = double.tryParse(value);
    if (parsed == null || !parsed.isFinite || parsed < 0) return 0;
    return isMillion ? parsed * 1000000 : parsed;
  }

  String _normalizeSingleSeparator(String value, String separator) {
    final parts = value.split(separator);
    if (parts.length <= 2 && parts.last.length != 3) {
      return value.replaceAll(separator, '.');
    }
    return value.replaceAll(separator, '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: Navigator.of(context).canPop()
          ? AppBar(title: const Text("PENGATURAN NILAI"))
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TENTUKAN\nNILAI WAKTU\nANDA",
                style: theme.textTheme.displayLarge?.copyWith(height: 0.9),
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),

              const SizedBox(height: 32),

              // Mode Selection Tabs
              Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                      label: "PEKERJA",
                      isSelected: !_isStudent,
                      onTap: () => setState(() => _isStudent = false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTabButton(
                      label: "PELAJAR",
                      isSelected: _isStudent,
                      onTap: () => setState(() => _isStudent = true),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 48),

              _buildInputLabel(
                _isStudent
                    ? "UANG SAKU BULANAN (IDR)"
                    : "PENDAPATAN BULANAN (IDR)",
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _incomeController,
                onChanged: (value) => _incomeInput = value,
                enableSuggestions: false,
                autocorrect: false,
                autofillHints: const [],
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: _isStudent ? "Contoh: 2000000" : "Contoh: 10000000",
                ),
              ),

              const SizedBox(height: 32),

              _buildInputLabel(
                _isStudent ? "JAM BELAJAR PER HARI" : "JAM KERJA PER HARI",
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _hoursController,
                onChanged: (value) => _hoursInput = value,
                enableSuggestions: false,
                autocorrect: false,
                autofillHints: const [],
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: theme.textTheme.bodyLarge,
                decoration: const InputDecoration(hintText: "Contoh: 8"),
              ),

              const SizedBox(height: 60),

              _buildBigButton(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFCCFF00) : Colors.transparent,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBigButton() {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: Stack(
        children: [
          Positioned(
            top: 4,
            left: 4,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
          Positioned.fill(
            right: 4,
            bottom: 4,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSave,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text("TETAPKAN NILAI SAYA"),
            ),
          ),
        ],
      ),
    ).animate().scale(delay: 400.ms);
  }

  Widget _buildInputLabel(String label) {
    return Text(label, style: Theme.of(context).textTheme.labelLarge);
  }
}
