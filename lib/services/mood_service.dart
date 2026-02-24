import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/mood_entry.dart';

/// Service class to handle mood tracking operations with Supabase
class MoodService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get the mood_entries table reference
  SupabaseQueryBuilder get _moodTable => _supabase.from('mood_entries');

  /// Add a new mood entry
  Future<MoodEntry> addMoodEntry(MoodEntry entry) async {
    try {
      final response = await _moodTable
          .insert(entry.toJson())
          .select()
          .single();

      return MoodEntry.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to add mood entry: $e');
    }
  }

  /// Get all mood entries for a user
  Future<List<MoodEntry>> getMoodEntries(String userId) async {
    try {
      final response = await _moodTable
          .select()
          .eq('user_id', userId)
          .order('date', ascending: false);

      if (response == null) return [];

      return (response as List<dynamic>)
          .map((json) => MoodEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch mood entries: $e');
    }
  }

  /// Get mood entries for a specific date range
  Future<List<MoodEntry>> getMoodEntriesInRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _moodTable
          .select()
          .eq('user_id', userId)
          .gte('date', startDate.toIso8601String())
          .lte('date', endDate.toIso8601String())
          .order('date', ascending: true);

      if (response == null) return [];

      return (response as List<dynamic>)
          .map((json) => MoodEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch mood entries in range: $e');
    }
  }

  /// Get weekly averages for mood, stress, and sleep
  Future<Map<String, double>> getWeeklyAverages(String userId) async {
    try {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));

      final entries = await getMoodEntriesInRange(userId, weekAgo, now);

      if (entries.isEmpty) {
        return {
          'mood': 0.0,
          'stress': 0.0,
          'sleep': 0.0,
        };
      }

      final avgMood = entries.map((e) => e.moodScore).reduce((a, b) => a + b) / entries.length;
      final avgStress = entries.map((e) => e.stressLevel).reduce((a, b) => a + b) / entries.length;
      final avgSleep = entries.map((e) => e.sleepHours).reduce((a, b) => a + b) / entries.length;

      return {
        'mood': avgMood,
        'stress': avgStress,
        'sleep': avgSleep,
      };
    } catch (e) {
      throw Exception('Failed to get weekly averages: $e');
    }
  }

  /// Get monthly averages for mood, stress, and sleep
  Future<Map<String, double>> getMonthlyAverages(String userId) async {
    try {
      final now = DateTime.now();
      final monthAgo = now.subtract(const Duration(days: 30));

      final entries = await getMoodEntriesInRange(userId, monthAgo, now);

      if (entries.isEmpty) {
        return {
          'mood': 0.0,
          'stress': 0.0,
          'sleep': 0.0,
        };
      }

      final avgMood = entries.map((e) => e.moodScore).reduce((a, b) => a + b) / entries.length;
      final avgStress = entries.map((e) => e.stressLevel).reduce((a, b) => a + b) / entries.length;
      final avgSleep = entries.map((e) => e.sleepHours).reduce((a, b) => a + b) / entries.length;

      return {
        'mood': avgMood,
        'stress': avgStress,
        'sleep': avgSleep,
      };
    } catch (e) {
      throw Exception('Failed to get monthly averages: $e');
    }
  }

  /// Delete a mood entry
  Future<void> deleteMoodEntry(String entryId) async {
    try {
      await _moodTable.delete().eq('id', entryId);
    } catch (e) {
      throw Exception('Failed to delete mood entry: $e');
    }
  }

  /// Get today's mood entry if exists
  Future<MoodEntry?> getTodayMoodEntry(String userId) async {
    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      final response = await _moodTable
          .select()
          .eq('user_id', userId)
          .gte('date', todayStart.toIso8601String())
          .lt('date', todayEnd.toIso8601String())
          .maybeSingle();

      if (response == null) return null;

      return MoodEntry.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Get the current user's ID
  String? getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }

  /// Mock data for development/testing
  List<MoodEntry> getMockEntries() {
    final userId = 'mock-user-id';
    return MoodEntry.getMockEntries(userId);
  }

  /// Mock weekly averages for development
  Map<String, double> getMockWeeklyAverages() {
    return {
      'mood': 3.5,
      'stress': 5.2,
      'sleep': 6.8,
    };
  }
}
