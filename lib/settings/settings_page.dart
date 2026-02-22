import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../config/theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSmall = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.getDarkCardColor() : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark ? AppTheme.darkGradient : AppTheme.lightGradient,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isSmall ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theme Section
                _SectionHeader(title: 'Appearance', isDark: isDark),
                const SizedBox(height: 12),
                _ThemeSettingCard(isDark: isDark),
                
                const SizedBox(height: 24),
                
                // About Section
                _SectionHeader(title: 'About', isDark: isDark),
                const SizedBox(height: 12),
                _AboutCard(isDark: isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.isDark});
  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }
}

class _ThemeSettingCard extends StatelessWidget {
  const _ThemeSettingCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.getDarkCardColor() : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.palette, color: Colors.deepPurple, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Customize the app appearance',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Theme mode options
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return Column(
                children: [
                  _ThemeOption(
                    title: 'Light',
                    subtitle: 'Always use light theme',
                    icon: Icons.wb_sunny_outlined,
                    isSelected: themeProvider.themeMode == AppThemeMode.light,
                    isDark: isDark,
                    onTap: () => themeProvider.setThemeMode(AppThemeMode.light),
                  ),
                  const SizedBox(height: 10),
                  _ThemeOption(
                    title: 'Dark',
                    subtitle: 'Always use dark theme',
                    icon: Icons.nightlight_round,
                    isSelected: themeProvider.themeMode == AppThemeMode.dark,
                    isDark: isDark,
                    onTap: () => themeProvider.setThemeMode(AppThemeMode.dark),
                  ),
                  const SizedBox(height: 10),
                  _ThemeOption(
                    title: 'System',
                    subtitle: 'Follow device settings',
                    icon: Icons.settings_brightness,
                    isSelected: themeProvider.themeMode == AppThemeMode.system,
                    isDark: isDark,
                    onTap: () => themeProvider.setThemeMode(AppThemeMode.system),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected 
                ? Colors.deepPurple.withOpacity(0.1) 
                : (isDark ? Colors.grey[800] : Colors.grey[50]),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Colors.deepPurple : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.deepPurple : (isDark ? Colors.white70 : Colors.grey[600]),
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.deepPurple : (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.deepPurple, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.getDarkCardColor() : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _AboutItem(
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: '1.0.0',
            isDark: isDark,
          ),
          const Divider(height: 24),
          _AboutItem(
            icon: Icons.code,
            title: 'Built with',
            subtitle: 'Flutter',
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _AboutItem extends StatelessWidget {
  const _AboutItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: isDark ? Colors.white70 : Colors.grey[600], size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white70 : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
