import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';

/// Provider class for managing user profile state
class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  UserProfile? _profile;
  bool _isLoading = false;
  String? _error;
  bool _useMockData = false;

  // Getters
  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get isAuthenticated => Supabase.instance.client.auth.currentUser != null;
  bool get hasProfile => _profile != null;

  /// Load profile for the currently authenticated user
  Future<void> loadProfile() async {
    _setLoading(true);
    _clearError();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      
      if (user == null) {
        _setError('No authenticated user found');
        _setLoading(false);
        return;
      }

      // Try to fetch from Supabase
      final profile = await _profileService.getProfile(user.id);
      
      if (profile != null) {
        _profile = profile;
        _useMockData = false;
      } else {
        // Profile doesn't exist in database
        _setError('Profile not found. Please complete your profile setup.');
      }
    } catch (e) {
      // If Supabase fails, use mock data for development
      _setError('Failed to load profile from server: $e');
      _profile = _profileService.getMockProfile();
      _useMockData = true;
    } finally {
      _setLoading(false);
    }
  }

  /// Load mock profile for development/testing
  void loadMockProfile() {
    _setLoading(true);
    _clearError();
    
    _profile = _profileService.getMockProfile();
    _useMockData = true;
    
    _setLoading(false);
  }

  /// Update user profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      
      if (user == null) {
        _setError('No authenticated user found');
        _setLoading(false);
        return false;
      }

      // If using mock data, just update locally
      if (_useMockData) {
        _profile = _profile?.copyWith(
          fullName: data['full_name'],
          jobTitle: data['job_title'],
          location: data['location'],
          bio: data['bio'],
          workStatus: data['work_status'],
          education: data['education'],
          phone: data['phone'],
          email: data['email'],
        );
        _setLoading(false);
        return true;
      }

      // Update in Supabase
      final updatedProfile = await _profileService.updateProfile(user.id, data);
      _profile = updatedProfile;
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update profile: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Create new profile for user
  Future<bool> createProfile(Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      
      if (user == null) {
        _setError('No authenticated user found');
        _setLoading(false);
        return false;
      }

      final newProfile = await _profileService.createProfile(user.id, data);
      _profile = newProfile;
      _useMockData = false;
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to create profile: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Refresh profile data from server
  Future<void> refreshProfile() async {
    await loadProfile();
  }

  /// Clear profile data (e.g., on logout)
  void clearProfile() {
    _profile = null;
    _error = null;
    _useMockData = false;
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
