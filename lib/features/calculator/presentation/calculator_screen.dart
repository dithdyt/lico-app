import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:lico/core/database/database_provider.dart';
import 'package:lico/features/ledger/domain/decision_log.dart';
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

  final List<String> _categories = [
    "🍔 Makanan & Kopi",
    "🔌 Gadget & Elektronik",
    "👕 Pakaian & Gaya Hidup",
    "🎮 Hobi & Hiburan",
    "🚗 Transportasi & Otomotif",
    "💄 Perawatan & Kosmetik",
    "📈 Investasi & Spekulasi",
    "🏠 Properti & Aset Besar",
    "📚 Edukasi & Karir",
    "📦 Lainnya",
  ];

  @override
  void initState() {
    super.initState();
    _loadCustomCategories();
  }

  Future<void> _loadCustomCategories() async {
    try {
      final isar = await ref.read(isarDatabaseProvider.future);
      final logs = await isar.decisionLogs.where().findAll();
      final uniqueCategories = logs.map((l) => l.category).toSet();

      setState(() {
        for (final cat in uniqueCategories) {
          if (!_categories.contains(cat) && cat.isNotEmpty) {
            // Insert before "📦 Lainnya" which is at the end of the list
            _categories.insert(_categories.length - 1, cat);
          }
        }
      });
    } catch (e) {
      // Ignore
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _monthsController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  void _addCustomCategory(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    // Convert to Title Case
    final titleCased = trimmed.split(RegExp(r'\s+')).map((w) {
      if (w.isEmpty) return '';
      return w[0].toUpperCase() + w.substring(1).toLowerCase();
    }).join(' ');

    String cleanString(String s) =>
        s.replaceAll(RegExp(r'[^\w\s&]'), '').trim().toLowerCase();

    final cleanInput = cleanString(titleCased);

    final existingIndex = _categories.indexWhere((cat) {
      return cleanString(cat) == cleanInput;
    });

    if (existingIndex != -1) {
      ref
          .read(calculatorNotifierProvider.notifier)
          .updateCategory(_categories[existingIndex]);
    } else {
      final newCategoryName = "🏷️ $titleCased";
      setState(() {
        _categories.insert(_categories.length - 1, newCategoryName);
      });
      ref
          .read(calculatorNotifierProvider.notifier)
          .updateCategory(newCategoryName);
    }
  }

  void _showAddCategoryDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: const ContinuousRectangleBorder(
            side: BorderSide(color: Colors.white, width: 3),
          ),
          title: const Text(
            "TAMBAH KATEGORI",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            cursorColor: const Color(0xFFCCFF00),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              hintText: "Contoh: Emas, Saham, Kripto",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text("BATAL", style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text;
                if (text.trim().isNotEmpty) {
                  _addCustomCategory(text);
                }
                Navigator.pop(context);
              },
              child: const Text("TAMBAH"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(calculatorNotifierProvider);
    final notifier = ref.read(calculatorNotifierProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("REALITY CHECK")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "APA YANG INGIN ANDA BELI?",
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),

            _buildLabel("NAMA BARANG"),
            _buildBrutalTextField(
              controller: _nameController,
              hint: "Misal: MacBook Pro M3",
              onChanged: notifier.updateItemName,
            ),

            const SizedBox(height: 24),

            _buildLabel("HARGA BARANG (RP)"),
            _buildBrutalTextField(
              controller: _priceController,
              hint: "0",
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (val) =>
                  notifier.updateItemPrice(double.tryParse(val) ?? 0),
            ),

            const SizedBox(height: 32),

            // Category Picker
            _buildCategoryPicker(state, notifier),

            const SizedBox(height: 32),

            // Paylater Toggle
            _buildBrutalToggle(
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
                        _buildBrutalTextField(
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
                        _buildBrutalTextField(
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

            _buildBigButton(
              label: "HITUNG BEBAN WAKTU",
              onPressed: () {
                if (state.itemName.isEmpty || state.itemPrice <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Isi nama dan harga barang dulu bray!"),
                    ),
                  );
                  return;
                }

                if (state.category.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text("Pilih kategori terlebih dahulu, bray!"),
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
                      category: newState.category,
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
      child: Text(label, style: Theme.of(context).textTheme.labelLarge),
    );
  }

  Widget _buildCategoryPicker(
    CalculatorState state,
    CalculatorNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("KATEGORI BARANG (WAJIB PILIH)"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ..._categories.map((cat) {
              final isSelected = state.category == cat;
              return GestureDetector(
                onTap: () => notifier.updateCategory(cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFCCFF00)
                        : const Color(0xFF1A1A1A),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }),
            GestureDetector(
              onTap: _showAddCategoryDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: const Color(0xFFCCFF00), width: 2),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Color(0xFFCCFF00), size: 16),
                    SizedBox(width: 4),
                    Text(
                      "TAMBAH KATEGORI",
                      style: TextStyle(
                        color: Color(0xFFCCFF00),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBrutalTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        cursorColor: const Color(0xFFCCFF00),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBrutalToggle({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: value ? const Color(0xFFCCFF00) : const Color(0xFF1A1A1A),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: value ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              value ? Icons.check_box : Icons.check_box_outline_blank,
              color: value ? Colors.black : Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBigButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFFCCFF00),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(color: Colors.white, offset: Offset(4, 4)),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
