import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../profile/profile_page.dart';
import '../chatbot/chatbot_page.dart';
import '../info/general_info_page.dart';
import '../mood/mood_page.dart';
import '../providers/theme_provider.dart';
import '../providers/mood_provider.dart';
import '../settings/settings_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, this.userName = 'Name'});
  final String userName;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Target health percent (0.0 - 1.0)
  final double _targetHealth = 0.72;
  // Example total time spent string
  final String _totalTime = '12h 30m';

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 600;
    final horizontalPadding = isSmall ? 16.0 : 32.0;
    final textScale = isSmall ? 1.0 : 1.1;

    // Use theme from provider
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // soft gradient background for comfortable UX
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0D1117), const Color(0xFF071019)]
                : [const Color(0xFFF7FAFF), const Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: greeting + small subtitle + avatar
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good day 👋',
                            style: TextStyle(
                              color: theme.textTheme.bodySmall?.color ?? Colors.grey[600],
                              fontSize: 14 * textScale,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                'Hi, ',
                                style: TextStyle(
                                  fontSize: 18 * textScale,
                                  color: theme.textTheme.bodyMedium?.color ?? Colors.grey[800],
                                ),
                              ),
                              Text(
                                widget.userName,
                                style: TextStyle(
                                  fontSize: 20 * textScale,
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.bodyLarge?.color ?? Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Light / Dark toggle placed left of the avatar
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, _) {
                        return IconButton(
                          tooltip: themeProvider.isDarkMode ? 'Switch to light' : 'Switch to dark',
                          icon: Icon(
                            themeProvider.isDarkMode
                                ? Icons.wb_sunny_outlined
                                : Icons.nightlight_round,
                          ),
                          color: theme.colorScheme.primary,
                          onPressed: () => themeProvider.toggleTheme(),
                        );
                      },
                    ),
                    const SizedBox(width: 6),
                    // Avatar with border (keeps navigation)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProfilePage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(isSmall ? 4 : 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF4A90E2),
                            width: isSmall ? 3 : 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4A90E2).withOpacity(0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: isSmall ? 26 : 32,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: _buildProfileImage(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Cards row: health, sessions, time
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildStatCard(context, 'Health', '${(_targetHealth * 100).toStringAsFixed(0)}%', Icons.favorite, Colors.pinkAccent, isSmall),
                    _buildStatCard(context, 'Sessions', '24', Icons.schedule, Colors.orangeAccent, isSmall),
                    _buildStatCard(context, 'Avg Time', '30m', Icons.timer, Colors.teal, isSmall),
                    _buildStatCard(context, 'Total Time', _totalTime, Icons.history, Colors.indigo, isSmall),
                  ],
                ),
                const SizedBox(height: 18),

                // Large card with a visual progress and CTA
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isSmall ? 14 : 18),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F1720) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withOpacity(0.6) : Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Progress',
                        style: TextStyle(fontSize: 16 * textScale, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: _targetHealth),
                        duration: const Duration(milliseconds: 900),
                        builder: (context, value, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinearProgressIndicator(
                                value: value,
                                minHeight: isSmall ? 10 : 14,
                                backgroundColor: Colors.grey[200],
                                color: Colors.greenAccent.shade700,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${(value * 100).toStringAsFixed(0)}% of goal',
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor),
                                    child: const Text('Continue', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Suggestion box: real-time help linking to General Info
                _SuggestionBox(
                  isDark: isDark,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GeneralInfoPage()),
                    );
                  },
                ),

                const SizedBox(height: 14),

                // Mood status card
                _MoodStatusCard(
                  isDark: isDark,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MoodPage()),
                    );
                  },
                ),

                const Spacer(),

                // CTA at bottom
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ChatbotPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: isSmall ? 14 : 16),
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'TALK TO SAMJHO',
                      style: TextStyle(fontSize: isSmall ? 16 : 18, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // helper to build profile image; change to SvgPicture.asset(...) if using svg
  Widget _buildProfileImage() {
    try {
      return SvgPicture.asset('assets/profile.svg', fit: BoxFit.cover);
    } catch (_) {
      return Image.network('https://placehold.co/200x200', fit: BoxFit.cover);
    }
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color, bool isSmall) {
    final width = (MediaQuery.of(context).size.width - (isSmall ? 32 : 64) - 12) / (isSmall ? 2 : 4);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF0F1720) : theme.cardColor;
    final shadowColor = isDark ? Colors.black.withOpacity(0.45) : Colors.black.withOpacity(0.03);
    final titleColor = isDark ? Colors.white70 : (theme.textTheme.bodySmall?.color ?? Colors.grey[700]);
    final valueColor = isDark ? Colors.white : (theme.textTheme.bodyLarge?.color ?? Colors.black87);
    final iconBg = isDark ? color.withOpacity(0.22) : color.withOpacity(0.12);

    return Container(
      width: isSmall ? width : 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: shadowColor, blurRadius: 8, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: isSmall ? 12 : 13, color: titleColor)),
                const SizedBox(height: 6),
                Text(value, style: TextStyle(fontSize: isSmall ? 14 : 16, fontWeight: FontWeight.w700, color: valueColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionBox extends StatelessWidget {
  const _SuggestionBox({required this.isDark, required this.onTap});
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = isDark ? const Color(0xFF0F1720) : Colors.white;
    final shadowColor = isDark ? Colors.black.withOpacity(0.6) : Colors.black.withOpacity(0.05);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: shadowColor, blurRadius: 12, offset: const Offset(0, 6))],
            border: Border.all(color: theme.colorScheme.primary.withOpacity(0.18), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.12), shape: BoxShape.circle),
                child: Icon(Icons.tips_and_updates, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Suggestions for You', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('Real-time tips and quick activities to feel better now.', style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.8))),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: theme.colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoodStatusCard extends StatelessWidget {
  const _MoodStatusCard({required this.isDark, required this.onTap});
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = isDark ? const Color(0xFF0F1720) : Colors.white;
    final shadowColor = isDark ? Colors.black.withOpacity(0.6) : Colors.black.withOpacity(0.05);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: shadowColor, blurRadius: 12, offset: const Offset(0, 6))],
            border: Border.all(color: Colors.purple.withOpacity(0.3), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mood, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Track Your Mood', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('Log daily mood, stress & sleep to see your patterns.', style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.8))),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.purple),
            ],
          ),
        ),
      ),
    );
  }
}
