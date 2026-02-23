import 'package:uuid/uuid.dart';

/// MoodEntry model representing a user's mood tracking entry
class MoodEntry {
  final String id;
  final DateTime date;
  final int moodScore; // 1-5 scale
  final int stressLevel; // 1-10 scale
  final double sleepHours;
  final String notes;
  final String userId;

  MoodEntry({
    String? id,
    required this.date,
    required this.moodScore,
    required this.stressLevel,
    required this.sleepHours,
    this.notes = '',
    required this.userId,
  }) : id = id ?? const Uuid().v4();

  /// Create MoodEntry from Supabase JSON data
  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      moodScore: json['mood_score'] as int,
      stressLevel: json['stress_level'] as int,
      sleepHours: (json['sleep_hours'] as num).toDouble(),
      notes: json['notes'] as String? ?? '',
      userId: json['user_id'] as String,
    );
  }

  /// Convert MoodEntry to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mood_score': moodScore,
      'stress_level': stressLevel,
      'sleep_hours': sleepHours,
      'notes': notes,
      'user_id': userId,
    };
  }

  /// Create a copy with updated fields
  MoodEntry copyWith({
    String? id,
    DateTime? date,
    int? moodScore,
    int? stressLevel,
    double? sleepHours,
    String? notes,
    String? userId,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      moodScore: moodScore ?? this.moodScore,
      stressLevel: stressLevel ?? this.stressLevel,
      sleepHours: sleepHours ?? this.sleepHours,
      notes: notes ?? this.notes,
      userId: userId ?? this.userId,
    );
  }

  /// Get mood emoji based on score
  String get moodEmoji {
    switch (moodScore) {
      case 1:
        return '😢';
      case 2:
        return '😔';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }

  /// Get mood label based on score
  String get moodLabel {
    switch (moodScore) {
      case 1:
        return 'Very Bad';
      case 2:
        return 'Bad';
      case 3:
        return 'Neutral';
      case 4:
        return 'Good';
      case 5:
        return 'Great';
      default:
        return 'Neutral';
    }
  }

  /// Mock data for development/testing
  static List<MoodEntry> getMockEntries(String userId) {
    final now = DateTime.now();
    return List.generate(7, (index) {
      return MoodEntry(
        id: const Uuid().v4(),
        date: now.subtract(Duration(days: index)),
        moodScore: 3 + (index % 3),
        stressLevel: 5 + (index % 4),
        sleepHours: 6.0 + (index % 3),
        notes: index % 2 == 0 ? 'Feeling okay today' : '',
        userId: userId,
      );
    });
  }
}
