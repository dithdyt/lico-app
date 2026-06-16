import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lico/core/utils/time_formatter.dart';
import 'package:lico/features/auth/presentation/edit_profile_page.dart';
import 'package:lico/features/auth/presentation/sign_in_screen.dart';
import 'package:lico/features/auth/providers/auth_provider.dart';
import '../providers/decision_provider.dart';
import '../providers/ledger_provider.dart';
import '../../calculator/presentation/calculator_screen.dart';
import '../../valuation/presentation/valuation_screen.dart';
import '../domain/decision_log.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledgerAsync = ref.watch(ledgerNotifierProvider);
    final userChanges = ref.watch(firebaseUserChangesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: userChanges.when(
          data: (user) => Text("HALO, ${_displayName(user)}"),
          loading: () => const Text("HALO, TAMU"),
          error: (err, stack) => const Text("HALO, TAMU"),
        ),
      ),
      drawer: const LicoAppDrawer(),
      body: ledgerAsync.when(
        data: (data) => _buildContent(context, ref, data, theme),
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

  String _displayName(User? user) {
    final name = user?.displayName?.trim();
    if (name == null || name.isEmpty) return "TAMU";
    return name.toUpperCase();
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    LedgerData data,
    ThemeData theme,
  ) {
    final remainingFormatted = TimeFormatter.formatHours(data.remainingTime);
    final todayBurnedFormatted = TimeFormatter.formatHours(
      data.todayBurnedHours,
    );
    final savedTotalFormatted = TimeFormatter.formatHours(data.totalSavedHours);
    final budgetFormatted = TimeFormatter.formatHours(data.timeBudget);
    final burnedTotalFormatted = TimeFormatter.formatHours(
      data.totalBurnedHours,
    );
    final headerBreakdown =
        "BUDGET: ${budgetFormatted.toUpperCase()} | TERPAKAI: ${burnedTotalFormatted.toUpperCase()}";
    final hourlyRateFormatted = _formatCurrency(data.hourlyRate);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Elegant Typography Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NILAI 1 JAM KERJA = $hourlyRateFormatted",
                  style: GoogleFonts.bebasNeue(
                    color: const Color(0xFFCCFF00),
                    fontSize: 18,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "SISA WAKTU BEBAS ANDA BULAN INI",
                  style: GoogleFonts.bebasNeue(
                    color: Colors.white70,
                    letterSpacing: 4.0,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    remainingFormatted.toUpperCase(),
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 72,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  headerBreakdown,
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSegmentedTimeGauge(data),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Daily Drain Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildBrutalInfoCard(
              title: "DAILY DRAIN",
              content:
                  "HARI INI ANDA MENUKARKAN $todayBurnedFormatted WAKTU KERJA UNTUK BELANJA.",
              accentColor: Colors.redAccent,
            ),
          ),

          const SizedBox(height: 16),

          // Time Vault Preview Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildBrutalInfoCard(
              title: "TIME VAULT PREVIEW",
              content:
                  "ANDA BERHASIL MENGAMANKAN $savedTotalFormatted WAKTU BEBAS DARI GODAAN BELANJA.",
              accentColor: const Color(0xFFCCFF00),
            ),
          ),

          const SizedBox(height: 48),

          // Tab Section
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  indicatorColor: const Color(0xFFCCFF00),
                  labelColor: const Color(0xFFCCFF00),
                  unselectedLabelColor: Colors.white70,
                  indicatorWeight: 4,
                  labelStyle: GoogleFonts.bebasNeue(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  unselectedLabelStyle: GoogleFonts.bebasNeue(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  tabs: const [
                    Tab(text: "TIME VAULT"),
                    Tab(text: "BURN LEDGER"),
                  ],
                ),
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    children: [
                      _buildLogList(ref, data.savedLogs),
                      _buildLogList(ref, data.burnedLogs),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedTimeGauge(LedgerData data) {
    final isDebt = data.remainingTime < 0;
    final progress = data.progress;
    final activeSegments = isDebt
        ? 10
        : (progress.isNaN || progress.isInfinite)
        ? 10
        : (progress * 10).clamp(0, 10).toInt();
    final activeColor = isDebt ? Colors.redAccent : const Color(0xFFCCFF00);

    return Row(
      children: List.generate(10, (index) {
        final isActive = index < activeSegments;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 28,
            margin: EdgeInsets.only(right: index == 9 ? 0 : 6),
            decoration: BoxDecoration(
              color: isActive ? activeColor : Colors.black,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBrutalInfoCard({
    required String title,
    required String content,
    required Color accentColor,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [BoxShadow(color: Colors.white, offset: Offset(5, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: accentColor,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text(
              title,
              style: GoogleFonts.bebasNeue(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Text(
              content,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogList(WidgetRef ref, List<DecisionLog> logs) {
    if (logs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white24,
              width: 2,
              style: BorderStyle.solid, // Fallback if dashed is too complex
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.white24,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  "BELUM ADA DATA",
                  style: GoogleFonts.bebasNeue(
                    color: Colors.white24,
                    fontSize: 24,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return _buildBrutalCard(ref, log);
      },
    );
  }

  Widget _buildBrutalCard(WidgetRef ref, DecisionLog log) {
    final formattedTime = TimeFormatter.formatHours(log.timeCostInHours);
    final formattedDate =
        "${log.createdAt.day}/${log.createdAt.month}/${log.createdAt.year}";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [BoxShadow(color: Colors.white, offset: Offset(4, 4))],
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
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            formattedTime.toUpperCase(),
            style: GoogleFonts.bebasNeue(
              color: const Color(0xFFCCFF00),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: "Hapus keputusan",
            onPressed: () {
              ref
                  .read(decisionNotifierProvider.notifier)
                  .deleteDecision(log.id);
            },
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value.isNaN || value.isInfinite) return "Rp 0";
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }
}

class LicoAppDrawer extends ConsumerWidget {
  const LicoAppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSession = ref.watch(authControllerProvider).valueOrNull;
    final isGuest = authSession?.user == null;

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
            icon: Icons.person_outline,
            label: "EDIT PROFIL",
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            label: "PENGATURAN NILAI WAKTU",
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ValuationScreen(),
                ),
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
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
            child: _buildDrawerItem(
              icon: isGuest ? Icons.login : Icons.logout,
              label: isGuest ? "MASUK" : "LOGOUT",
              color: Colors.white70,
              onTap: () async {
                Navigator.pop(context);
                if (isGuest) {
                  await ref
                      .read(authControllerProvider.notifier)
                      .exitGuestMode();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                      (route) => false,
                    );
                  }
                  return;
                }

                await ref.read(authControllerProvider.notifier).signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color == Colors.white ? const Color(0xFFCCFF00) : color,
      ),
      title: Text(
        label,
        style: GoogleFonts.bebasNeue(color: color, fontSize: 20),
      ),
      onTap: onTap,
    );
  }
}
