import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/valuation_provider.dart';

class ValuationScreen extends ConsumerStatefulWidget {
  const ValuationScreen({super.key});

  @override
  ConsumerState<ValuationScreen> createState() => _ValuationScreenState();
}

class _ValuationScreenState extends ConsumerState<ValuationScreen> {
  final _incomeController = TextEditingController();
  final _hoursController = TextEditingController();
  bool _isLoading = false;
  bool _isStudent = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentValuation = ref.read(valuationNotifierProvider).value;
      if (currentValuation != null) {
        _incomeController.text = currentValuation.monthlyIncome.toStringAsFixed(0);
        _hoursController.text = currentValuation.weeklyWorkHours.toStringAsFixed(0);
      }
    });
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final income = double.tryParse(_incomeController.text) ?? 0;
    final hours = double.tryParse(_hoursController.text) ?? 0;

    if (income <= 0 || hours <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Harap masukkan nilai yang valid dan lebih besar dari 0."),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      await ref.read(valuationNotifierProvider.notifier).saveValuation(
            monthlyIncome: income,
            weeklyWorkHours: hours,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(e.toString()),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                "BERAPA HARGA\n1 JAM HIDUP\nANDA?",
                style: theme.textTheme.displayLarge?.copyWith(
                  height: 0.9,
                ),
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
              
              _buildInputLabel(_isStudent ? "UANG SAKU BULANAN (IDR)" : "PENDAPATAN BULANAN (IDR)"),
              const SizedBox(height: 12),
              TextField(
                controller: _incomeController,
                keyboardType: TextInputType.number,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: _isStudent ? "Contoh: 2000000" : "Contoh: 10000000",
                ),
              ),
              
              const SizedBox(height: 32),
              
              _buildInputLabel(_isStudent ? "JAM BELAJAR PER MINGGU" : "JAM KERJA PER MINGGU"),
              const SizedBox(height: 12),
              TextField(
                controller: _hoursController,
                keyboardType: TextInputType.number,
                style: theme.textTheme.bodyLarge,
                decoration: const InputDecoration(
                  hintText: "Contoh: 40",
                ),
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
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}
