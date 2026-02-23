import 'package:flutter/foundation.dart';
import '../models/mood_entry.dart';
import '../services/mood_service.dart';

/// Provider for mood tracking state management
class MoodProvider extends ChangeNotifier {
  final MoodService _moodService = MoodService();

  List<MoodEntry> _moodEntries = [];
  Map<String, double> _weeklyAverages = {};
  Map<String, double> _monthlyAverages = {};
  MoodEntry? _todayEntry;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<MoodEntry> get moodEntries => _moodEntries;
  Map<String, double> get weeklyAverages => _weeklyAverages;
  Map<String, double> get monthlyAverages => _monthlyAverages;
  MoodEntry? get todayEntry => _todayEntry;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  /// Load all mood data for the current user
  Future<void> loadMoodData() async {
    _setLoading(true);
    _clearError();

    try {
      final userId = _moodService.getCurrentUserId();
      
      if (userId == null) {
        // Use mock data for development
        _moodEntries = _moodService.getMockEntries();
        _weeklyAverages = _moodService.getMockWeeklyAverages();
        _monthlyAverages = _moodService.getMockWeeklyAverages();
        _todayEntry = _moodEntries.isNotEmpty ? _moodEntries.first : null;
        notifyListeners();
        return;
      }

      // Fetch all data in parallel
      final results = await Future.wait([
        _moodService.getMoodEntries(userId),
        _moodService.getWeeklyAverages(userId),
        _moodService.getMonthlyAverages(userId),
        _moodService.getTodayMoodEntry(userId),
      ]);

      _moodEntries = results[0] as List<MoodEntry>;
      _weeklyAverages = results[1] as Map<String, double>;
      _monthlyAverages = results[2] as Map<String, double>;
      _todayEntry = results[3] as MoodEntry?;

      notifyListeners();
    } catch (e) {
      _setError('Failed to load mood data: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Add a new mood entry
  Future<bool> addMoodEntry({
    required int moodScore,
    required int stressLevel,
    required double sleepHours,
    String notes = '',
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final userId = _moodService.getCurrentUserId() ?? 'mock-user-id';

      final entry = MoodEntry(
        date: DateTime.now(),
        moodScore: moodScore,
        stressLevel: stressLevel,
        sleepHours: sleepHours,
        notes: notes,
        userId: userId,
      );

      final savedEntry = await _moodService.addMoodEntry(entry);

      // Update local state
      _moodEntries.insert(0, savedEntry);
      _todayEntry = savedEntry;

      // Recalculate averages
      await _loadAverages(userId);

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to add mood entry: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a mood entry
  Future<bool> deleteMoodEntry(String entryId) async {
    _setLoading(true);
    _clearError();

    try {
      await _moodService.deleteMoodEntry(entryId);

      // Update local state
      _moodEntries.removeWhere((entry) => entry.id == entryId);
      
      // Update today entry if needed
      if (_todayEntry?.id == entryId) {
        _todayEntry = null;
      }

      // Recalculate averages
      final userId = _moodService.getCurrentUserId() ?? 'mock-user-id';
      await _loadAverages(userId);

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete mood entry: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get recent entries for charts (last 7 days)
  List<MoodEntry> getRecentEntries() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    
    return _moodEntries
        .where((entry) => entry.date.isAfter(weekAgo))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Clear all mood data
  void clearMoodData() {
    _moodEntries = [];
    _weeklyAverages = {};
    _monthlyAverages = {};
    _todayEntry = null;
    _error = null;
    notifyListeners();
  }

  // Private helper methods
  Future<void> _loadAverages(String userId) async {
    try {
      final results = await Future.wait([
        _moodService.getWeeklyAverages(userId),
        _moodService.getMonthlyAverages(userId),
      ]);

      _weeklyAverages = results[0] as Map<String, double>;
      _monthlyAverages = results[1] as Map<String, double>;
    } catch (e) {
      // Keep existing averages on error
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
