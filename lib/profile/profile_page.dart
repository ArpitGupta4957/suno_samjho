import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../config/theme.dart';
import '../settings/settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load profile when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 600;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final profile = profileProvider.profile;
        final isLoading = profileProvider.isLoading;
        
        // Show loading indicator while loading
        if (isLoading && profile == null) {
          return Scaffold(
            backgroundColor: isDark ? AppTheme.getDarkCardColor() : Colors.white,
            appBar: AppBar(
              backgroundColor: isDark ? AppTheme.getDarkCardColor() : Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black87),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Use profile data or fallback to empty strings
        final fullName = profile?.fullName ?? 'User';
        final jobTitle = profile?.jobTitle ?? '';
        final location = profile?.location ?? '';
        final bio = profile?.bio ?? '';
        final interests = profile?.interests ?? [];
        final workStatus = profile?.workStatus ?? '';
        final education = profile?.education ?? '';
        final email = profile?.email ?? '';
        final phone = profile?.phone ?? '';

        return Scaffold(
          backgroundColor: isDark ? AppTheme.getDarkCardColor() : Colors.white,
          appBar: AppBar(
            backgroundColor: isDark ? AppTheme.getDarkCardColor() : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black87),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings, color: isDark ? Colors.white70 : Colors.black54),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: isSmall ? 16 : 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Error message if any
                  if (profileProvider.hasError)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(profileProvider.error!, style: TextStyle(color: Colors.orange.shade800, fontSize: 13)),
                          ),
                          TextButton(onPressed: () => profileProvider.loadProfile(), child: const Text('Retry')),
                        ],
                      ),
                    ),
                  
                  // Header card with avatar and name
                  Container(
                    padding: EdgeInsets.all(isSmall ? 16 : 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark ? [const Color(0xFF1E293B), const Color(0xFF0F1720)] : [const Color(0xFFEEF2FF), const Color(0xFFFFFFFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.04), blurRadius: 12, offset: const Offset(0, 6))],
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: isSmall ? 44 : 56,
                            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                            child: ClipOval(
                              child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: _buildAvatar(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: isSmall ? 12 : 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(fullName, style: TextStyle(fontSize: isSmall ? 18 : 22, fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black87)),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit, size: 16),
                                    label: const Text('Edit'),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                                      foregroundColor: isDark ? Colors.white : Colors.black87,
                                      side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey.shade200),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              if (jobTitle.isNotEmpty) Text(jobTitle, style: TextStyle(fontSize: isSmall ? 13 : 15, color: isDark ? Colors.white70 : Colors.grey[700])),
                              if (location.isNotEmpty) const SizedBox(height: 6),
                              if (location.isNotEmpty)
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: isSmall ? 14 : 16, color: isDark ? Colors.white60 : Colors.grey[500]),
                                    const SizedBox(width: 6),
                                    Text(location, style: TextStyle(color: isDark ? Colors.white60 : Colors.grey[600], fontSize: isSmall ? 12 : 13)),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Bio / About
                  if (bio.isNotEmpty) ...[
                    Text('About', style: TextStyle(fontSize: isSmall ? 16 : 18, fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black87)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey.shade100),
                      ),
                      child: Text(bio, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[800], height: 1.4, fontSize: isSmall ? 13 : 14)),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Interests chips
                  if (interests.isNotEmpty) ...[
                    Text('Interests & Hobbies', style: TextStyle(fontSize: isSmall ? 16 : 18, fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black87)),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, runSpacing: 8, children: interests.map((interest) => _buildChip(interest, isDark)).toList()),
                    const SizedBox(height: 16),
                  ],

                  // Details list
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F1720) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.03), blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      children: [
                        if (workStatus.isNotEmpty) ...[_buildDetailRow(Icons.work, 'Work status', workStatus, isDark), const Divider(height: 20)],
                        if (education.isNotEmpty) ...[_buildDetailRow(Icons.school, 'Education', education, isDark), const Divider(height: 20)],
                        if (email.isNotEmpty) ...[_buildDetailRow(Icons.email, 'Email', email, isDark), const Divider(height: 20)],
                        if (phone.isNotEmpty) _buildDetailRow(Icons.phone, 'Phone', phone, isDark),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text('Message'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.call_outlined),
                          label: const Text('Call'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () async {
                        context.read<ProfileProvider>().clearProfile();
                        await Supabase.instance.client.auth.signOut();
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.logout, color: Colors.redAccent),
                      label: Text('Logout', style: TextStyle(fontSize: isSmall ? 16 : 18, fontWeight: FontWeight.w600, color: Colors.redAccent)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.redAccent.withOpacity(0.2))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar() {
    try {
      return SvgPicture.asset('assets/profile.svg', fit: BoxFit.cover);
    } catch (_) {
      return Image.network('https://placehold.co/200x200', fit: BoxFit.cover);
    }
  }

  Widget _buildChip(String label, bool isDark) {
    return Chip(
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: isDark ? Colors.grey[700] : const Color(0xFFF2F6FF),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: isDark ? Colors.white70 : Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 6),
              Text(value, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700])),
            ],
          ),
        ),
      ],
    );
  }
}
