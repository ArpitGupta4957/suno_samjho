import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

/// Service class to handle profile-related operations with Supabase
class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get the profiles table reference
  SupabaseQueryBuilder get _profilesTable => _supabase.from('profiles');

  /// Fetch user profile by user ID
  /// Returns UserProfile if found, null otherwise
  Future<UserProfile?> getProfile(String userId) async {
    try {
      final response = await _profilesTable
          .select()
          .eq('id', userId)
          .single();

      if (response == null) return null;

      return UserProfile.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      // Handle specific Supabase errors
      if (e.code == 'PGRST116') {
        // No rows returned - profile doesn't exist
        return null;
      }
      rethrow;
    } catch (e) {
      // Handle other errors
      throw Exception('Failed to fetch profile: $e');
    }
  }

  /// Create or update user profile
  /// Uses upsert to handle both create and update operations
  Future<UserProfile> updateProfile(String userId, Map<String, dynamic> data) async {
    try {
      final profileData = {
        'id': userId,
        ...data,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _profilesTable
          .upsert(profileData)
          .select()
          .single();

      return UserProfile.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Create a new profile for a user
  Future<UserProfile> createProfile(String userId, Map<String, dynamic> data) async {
    try {
      final profileData = {
        'id': userId,
        ...data,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _profilesTable
          .insert(profileData)
          .select()
          .single();

      return UserProfile.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create profile: $e');
    }
  }

  /// Check if profile exists for a user
  Future<bool> profileExists(String userId) async {
    try {
      final response = await _profilesTable
          .select('id')
          .eq('id', userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  /// Get current user's profile using the authenticated user ID
  Future<UserProfile?> getCurrentUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    return await getProfile(user.id);
  }

  /// Mock profile for development/testing when Supabase is unavailable
  UserProfile getMockProfile() {
    return UserProfile.mockProfile;
  }
}
