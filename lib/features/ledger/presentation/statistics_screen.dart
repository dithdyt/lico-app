import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lico/core/utils/time_formatter.dart';
import '../providers/ledger_provider.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  bool _showSaved = true; // true = Saved (Time Vault), false = Burned (Bought)
  int? _touchedIndex;

  final List<Color> _colorPalette = [
    const Color(0xFFCCFF00), // Neon Yellow
    const Color(0xFFFF3B30), // Error Red
    const Color(0xFF34C759), // Success Green
    const Color(0xFF00C7FF), // Cyan
    const Color(0xFFFF9500), // Orange
    const Color(0xFFAF52DE), // Purple
    const Color(0xFF5AC8FA), // Light Blue
    const Color(0xFFFFCC00), // Yellow
    const Color(0xFFE5E5EA), // Light Grey
    const Color(0xFFFF2D55), // Pink
  ];

  @override
  Widget build(BuildContext context) {
    final ledgerAsync = ref.watch(ledgerNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("ANALISIS & STATISTIK"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFCCFF00)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ledgerAsync.when(
        data: (data) => _buildBody(data, theme),
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFCCFF00)),
        ),
        error: (err, stack) => Center(
          child: Text(
            "Error: $err",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(LedgerData data, ThemeData theme) {
    // 1. Group data by category
    final Map<String, double> categoryHours = {};
    double totalHours = 0;

    final targetLogs = _showSaved ? data.savedLogs : data.burnedLogs;

    for (final log in targetLogs) {
      final category = log.category.isEmpty ? "📦 Lainnya" : log.category;
      categoryHours[category] =
          (categoryHours[category] ?? 0) + log.timeCostInHours;
      totalHours += log.timeCostInHours;
    }

    // Sort categories by hours descending
    final sortedCategories = categoryHours.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Get insights
    String largestCategory = "";
    double largestHours = 0;
    double largestPercentage = 0;

    if (sortedCategories.isNotEmpty) {
      largestCategory = sortedCategories.first.key;
      largestHours = sortedCategories.first.value;
      largestPercentage =
          totalHours > 0 ? (largestHours / totalHours) * 100 : 0;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mode Switcher Tabs
          Row(
            children: [
              Expanded(
                child: _buildTabButton(
                  label: "TIME VAULT (SAVED)",
                  isSelected: _showSaved,
                  onTap: () => setState(() {
                    _showSaved = true;
                    _touchedIndex = null;
                  }),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTabButton(
                  label: "BURN LEDGER (BOUGHT)",
                  isSelected: !_showSaved,
                  onTap: () => setState(() {
                    _showSaved = false;
                    _touchedIndex = null;
                  }),
                ),
              ),
            ],
          ),

          const SizedBox(height: 36),

          if (totalHours == 0) ...[
            _buildEmptyState()
          ] else ...[
            // Chart Display
            _buildChartCard(sortedCategories, totalHours, theme),

            const SizedBox(height: 32),

            // Legend/List Display
            _buildLegendList(sortedCategories, totalHours, theme),

            const SizedBox(height: 36),

            // Insight Section
            _buildInsightCard(
              largestCategory: largestCategory,
              hours: largestHours,
              percentage: largestPercentage,
              theme: theme,
            ),
          ],
        ],
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
            style: GoogleFonts.bebasNeue(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.analytics_outlined,
              color: Colors.white24,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              "BELUM ADA DATA UNTUK BULAN INI",
              style: GoogleFonts.bebasNeue(
                color: Colors.white24,
                fontSize: 20,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(
    List<MapEntry<String, double>> categories,
    double total,
    ThemeData theme,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [BoxShadow(color: Colors.white, offset: Offset(4, 4))],
      ),
      child: Column(
        children: [
          Text(
            _showSaved ? "WAKTU BEBAS TERSELAMATKAN" : "WAKTU KERJA TERBAKAR",
            style: GoogleFonts.bebasNeue(
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            TimeFormatter.formatHours(total).toUpperCase(),
            style: GoogleFonts.bebasNeue(
              color: const Color(0xFFCCFF00),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 4,
                centerSpaceRadius: 50,
                sections: List.generate(categories.length, (index) {
                  final cat = categories[index];
                  final isTouched = index == _touchedIndex;
                  final double radius = isTouched ? 30.0 : 20.0;
                  final double percentage = (cat.value / total) * 100;
                  final color = _colorPalette[index % _colorPalette.length];

                  return PieChartSectionData(
                    color: color,
                    value: cat.value,
                    title: isTouched ? '${percentage.toStringAsFixed(1)}%' : '',
                    radius: radius,
                    titleStyle: GoogleFonts.bebasNeue(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendList(
    List<MapEntry<String, double>> categories,
    double total,
    ThemeData theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (context, index) =>
            const Divider(color: Colors.white24, height: 1, thickness: 1),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final color = _colorPalette[index % _colorPalette.length];
          final percentage = (cat.value / total) * 100;
          final formattedTime = TimeFormatter.formatHours(cat.value);

          return ListTile(
            leading: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
            title: Text(
              cat.key.toUpperCase(),
              style: GoogleFonts.bebasNeue(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 1.0,
              ),
            ),
            subtitle: Text(
              formattedTime,
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Text(
              "${percentage.toStringAsFixed(1)}%",
              style: GoogleFonts.bebasNeue(
                color: const Color(0xFFCCFF00),
                fontSize: 20,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInsightCard({
    required String largestCategory,
    required double hours,
    required double percentage,
    required ThemeData theme,
  }) {
    final formattedTime = TimeFormatter.formatHours(hours);

    String title = "";
    String detail = "";
    Color cardColor = Colors.black;
    Color borderAccentColor = Colors.white;

    if (_showSaved) {
      title = "PENYELAMAT WAKTU TERBAIK";
      detail =
          "Kamu berhasil mengamankan $formattedTime waktu kerjamu (${percentage.toStringAsFixed(1)}% dari total godaan belanja) di kategori $largestCategory.";
      cardColor = const Color(0xFF1A1A1A);
      borderAccentColor = const Color(0xFFCCFF00);
    } else {
      title = "KELEMAHAN TERBESAR";
      detail =
          "Waktu kerjamu paling banyak terkuras di kategori $largestCategory sebesar $formattedTime (${percentage.toStringAsFixed(1)}% dari total pengeluaran).";
      cardColor = const Color(0xFF1A1A1A);
      borderAccentColor = Colors.redAccent;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: borderAccentColor, width: 2),
        boxShadow: [
          BoxShadow(color: borderAccentColor, offset: const Offset(4, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: borderAccentColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: GoogleFonts.bebasNeue(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              detail.toUpperCase(),
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
