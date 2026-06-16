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
        loading: () => Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
        error: (err, stack) => Center(
          child: Text(
            "Error: $err",
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CalculatorScreen()),
          );
        },
        child: const Icon(Icons.add, size: 28),
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
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NILAI 1 JAM KERJA = $hourlyRateFormatted",
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "SISA WAKTU BEBAS ANDA BULAN INI",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 12),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    remainingFormatted.toUpperCase(),
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.black,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  headerBreakdown,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSegmentedTimeGauge(context, data),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Daily Drain Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildInfoCard(
              theme: theme,
              title: "DAILY DRAIN",
              content:
                  "Hari ini Anda menukarkan $todayBurnedFormatted waktu kerja untuk berbelanja barang konsumtif.",
              accentColor: theme.colorScheme.error,
            ),
          ),

          const SizedBox(height: 16),

          // Time Vault Preview Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildInfoCard(
              theme: theme,
              title: "TIME VAULT PREVIEW",
              content:
                  "Anda berhasil mengamankan $savedTotalFormatted waktu bebas dengan menunda godaan belanja.",
              accentColor: const Color(0xFF10B981), // Emerald Success Green
            ),
          ),

          const SizedBox(height: 32),

          // Tab Section
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  indicatorColor: theme.colorScheme.primary,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.5),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: theme.colorScheme.onSurface.withOpacity(0.05),
                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                    letterSpacing: 1.0,
                  ),
                  unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
                    letterSpacing: 1.0,
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
                      _buildLogList(context, ref, data.savedLogs, isSavedLog: true),
                      _buildLogList(context, ref, data.burnedLogs, isSavedLog: false),
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

  Widget _buildSegmentedTimeGauge(BuildContext context, LedgerData data) {
    final theme = Theme.of(context);
    final isDebt = data.remainingTime < 0;
    final progress = data.progress;
    final activeSegments = isDebt
        ? 10
        : (progress.isNaN || progress.isInfinite)
        ? 10
        : (progress * 10).clamp(0, 10).toInt();
    final activeColor = isDebt ? theme.colorScheme.error : theme.colorScheme.primary;

    return Row(
      children: List.generate(10, (index) {
        final isActive = index < activeSegments;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 16,
            margin: EdgeInsets.only(right: index == 9 ? 0 : 4),
            decoration: BoxDecoration(
              color: isActive ? activeColor : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: theme.colorScheme.onSurface.withOpacity(0.05),
                width: 1,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard({
    required ThemeData theme,
    required String title,
    required String content,
    required Color accentColor,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.08),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: accentColor.withOpacity(0.08),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: accentColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogList(
    BuildContext context,
    WidgetRef ref,
    List<DecisionLog> logs, {
    required bool isSavedLog,
  }) {
    final theme = Theme.of(context);
    if (logs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.08),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  "BELUM ADA DATA",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
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
        return _buildTransactionCard(context, ref, log, isSavedLog);
      },
    );
  }

  Widget _buildTransactionCard(
    BuildContext context,
    WidgetRef ref,
    DecisionLog log,
    bool isSavedLog,
  ) {
    final theme = Theme.of(context);
    final formattedTime = TimeFormatter.formatHours(log.timeCostInHours);
    final formattedDate =
        "${log.createdAt.day}/${log.createdAt.month}/${log.createdAt.year}";

    final timeValueColor = isSavedLog ? const Color(0xFF10B981) : theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.05),
          width: 1.0,
        ),
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
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            formattedTime.toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(
              color: timeValueColor,
              fontSize: 18,
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
            icon: Icon(
              Icons.delete_outline,
              color: theme.colorScheme.error.withOpacity(0.8),
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
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.onSurface.withOpacity(0.05),
                  width: 1,
                ),
              ),
            ),
            child: Center(
              child: Text(
                "LICO",
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.black,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.dashboard_outlined,
            label: "DASHBOARD",
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            context: context,
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
            context: context,
            icon: Icons.settings_outlined,
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
            context: context,
            icon: Icons.info_outline,
            label: "TENTANG LICO",
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: "LICO",
                applicationVersion: "1.0.0",
                applicationLegalese: "© 2026 LICO Decision Audit Tool",
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
            child: _buildDrawerItem(
              context: context,
              icon: isGuest ? Icons.login : Icons.logout,
              label: isGuest ? "MASUK" : "LOGOUT",
              color: theme.colorScheme.onSurface.withOpacity(0.6),
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
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final activeColor = color ?? theme.colorScheme.onSurface;
    final iconColor = color ?? theme.colorScheme.primary;

    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: activeColor,
          letterSpacing: 1.0,
        ),
      ),
      onTap: onTap,
    );
  }
}
