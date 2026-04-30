import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lico/core/utils/time_formatter.dart';
import '../providers/ledger_provider.dart';
import '../../calculator/presentation/calculator_screen.dart';
import '../../valuation/presentation/valuation_screen.dart';
import '../domain/decision_log.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledgerAsync = ref.watch(ledgerNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("TIME VAULT & LEDGER"),
      ),
      drawer: _buildDrawer(context, ref),
      body: ledgerAsync.when(
        data: (data) => _buildContent(context, data, theme),
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFCCFF00))),
        error: (err, stack) => Center(child: Text("Error: $err", style: const TextStyle(color: Colors.white))),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFCCFF00),
        shape: const ContinuousRectangleBorder(
          side: BorderSide(color: Colors.white, width: 2),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CalculatorScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.black, size: 32),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white, width: 2)),
            ),
            child: Center(
              child: Text(
                "LICO",
                style: GoogleFonts.bebasNeue(
                  color: const Color(0xFFCCFF00),
                  fontSize: 48,
                ),
              ),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.dashboard,
            label: "DASHBOARD",
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            label: "EDIT NILAI HIDUP",
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ValuationScreen()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.info_outline,
            label: "TENTANG LICO",
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: "LICO",
                applicationVersion: "1.0.0",
                applicationLegalese: "© 2024 LICO Decision Audit Tool",
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFCCFF00)),
      title: Text(
        label,
        style: GoogleFonts.bebasNeue(color: Colors.white, fontSize: 20),
      ),
      onTap: onTap,
    );
  }

  Widget _buildContent(BuildContext context, LedgerData data, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Summary
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "TOTAL WAKTU TERSELAMATKAN",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  TimeFormatter.formatHours(data.totalSavedHours).toUpperCase(),
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: const Color(0xFFCCFF00),
                    fontSize: 64,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Chart Section
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: data.allLogs.isEmpty 
                ? const Center(
                    child: Text(
                      "Belum ada data penderitaan/kemenangan hari ini.",
                      style: TextStyle(color: Colors.white38),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(child: _buildBarChart(data)),
                      const SizedBox(height: 16),
                      // Legend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem(const Color(0xFFCCFF00), "SAVED"),
                          const SizedBox(width: 24),
                          _buildLegendItem(Colors.red, "BURNED"),
                        ],
                      ),
                    ],
                  ),
          ),
        ),

        const SizedBox(height: 32),

        // Tab Section
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  indicatorColor: Color(0xFFCCFF00),
                  labelColor: Color(0xFFCCFF00),
                  unselectedLabelColor: Colors.white70,
                  indicatorWeight: 4,
                  tabs: [
                    Tab(text: "TIME VAULT"),
                    Tab(text: "BURN LEDGER"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildLogList(data.savedLogs),
                      _buildLogList(data.burnedLogs),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.white, width: 1),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.bebasNeue(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(LedgerData data) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (data.totalSavedHours > data.totalBurnedHours 
            ? data.totalSavedHours 
            : data.totalBurnedHours) * 1.2 + 1,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12);
                switch (value.toInt()) {
                  case 0: return const Text('SAVED', style: style);
                  case 1: return const Text('BURNED', style: style);
                  default: return const Text('');
                }
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: data.totalSavedHours,
                color: const Color(0xFFCCFF00),
                width: 60,
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: data.totalBurnedHours,
                color: Colors.red,
                width: 60,
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogList(List<DecisionLog> logs) {
    if (logs.isEmpty) {
      return const Center(
        child: Text(
          "BELUM ADA DATA",
          style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return _buildBrutalCard(log);
      },
    );
  }

  Widget _buildBrutalCard(DecisionLog log) {
    final formattedTime = TimeFormatter.formatHours(log.timeCostInHours);
    final formattedDate = "${log.createdAt.day}/${log.createdAt.month}/${log.createdAt.year}";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.itemName.toUpperCase(),
                  style: GoogleFonts.bebasNeue(
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: GoogleFonts.inter(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formattedTime.toUpperCase(),
            style: GoogleFonts.bebasNeue(
              color: const Color(0xFFCCFF00),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
