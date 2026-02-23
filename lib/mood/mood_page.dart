import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/mood_provider.dart';
import '../config/theme.dart';
import '../models/mood_entry.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  int _selectedMood = 3;
  double _stressLevel = 5.0;
  double _sleepHours = 7.0;
  final TextEditingController _notesController = TextEditingController();

  // Emoji options for mood selection
  final List<Map<String, dynamic>> _moodOptions = [
    {'score': 1, 'emoji': '😢', 'label': 'Very Bad'},
    {'score': 2, 'emoji': '😔', 'label': 'Bad'},
    {'score': 3, 'emoji': '😐', 'label': 'Neutral'},
    {'score': 4, 'emoji': '😊', 'label': 'Good'},
    {'score': 5, 'emoji': '😄', 'label': 'Great'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MoodProvider>().loadMoodData();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 600;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.getDarkCardColor() : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.getDarkCardColor() : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Mood Tracking',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<MoodProvider>(
        builder: (context, moodProvider, child) {
          if (moodProvider.isLoading && moodProvider.moodEntries.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isSmall ? 16 : 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Today's mood entry section
                _buildSectionTitle('How are you feeling today?', isDark),
                const SizedBox(height: 16),
                
                // Mood selection
                _buildMoodSelector(isDark),
                const SizedBox(height: 24),

                // Stress level slider
                _buildSectionTitle('Stress Level', isDark),
                const SizedBox(height: 8),
                _buildStressSlider(isDark, isSmall),
                const SizedBox(height: 24),

                // Sleep hours input
                _buildSectionTitle('Sleep Hours', isDark),
                const SizedBox(height: 8),
                _buildSleepInput(isDark, isSmall),
                const SizedBox(height: 24),

                // Notes input
                _buildSectionTitle('Notes (optional)', isDark),
                const SizedBox(height: 8),
                _buildNotesInput(isDark),
                const SizedBox(height: 24),

                // Save button
                _buildSaveButton(moodProvider, isDark, isSmall),
                const SizedBox(height: 32),

                // Analytics section
                _buildSectionTitle('Your Analytics', isDark),
                const SizedBox(height: 16),
                
                // Weekly averages
                _buildWeeklyAveragesCard(moodProvider, isDark, isSmall),
                const SizedBox(height: 16),

                // Mood trend chart
                _buildMoodTrendChart(moodProvider, isDark, isSmall),
                const SizedBox(height: 16),

                // Sleep pattern visualization
                _buildSleepPatternChart(moodProvider, isDark, isSmall),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildMoodSelector(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _moodOptions.map((option) {
          final isSelected = _selectedMood == option['score'];
          return GestureDetector(
            onTap: () => setState(() => _selectedMood = option['score']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? Colors.blue[700] : Colors.blue[50])
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Colors.blue
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    option['emoji'],
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option['label'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? (isDark ? Colors.white : Colors.blue[700])
                          : (isDark ? Colors.white70 : Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStressSlider(bool isDark, bool isSmall) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Low', style: TextStyle(color: Colors.green)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _getStressColor(_stressLevel.toInt()),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_stressLevel.toInt()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Text('High', style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _getStressColor(_stressLevel.toInt()),
              thumbColor: _getStressColor(_stressLevel.toInt()),
            ),
            child: Slider(
              value: _stressLevel,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (value) => setState(() => _stressLevel = value),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStressColor(int level) {
    if (level <= 3) return Colors.green;
    if (level <= 6) return Colors.orange;
    return Colors.red;
  }

  Widget _buildSleepInput(bool isDark, bool isSmall) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              if (_sleepHours > 0) {
                setState(() => _sleepHours -= 0.5);
              }
            },
            icon: Icon(
              Icons.remove_circle_outline,
              color: isDark ? Colors.white70 : Colors.grey[700],
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              Text(
                '${_sleepHours.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: isSmall ? 32 : 40,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                'hours',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              if (_sleepHours < 24) {
                setState(() => _sleepHours += 0.5);
              }
            },
            icon: Icon(
              Icons.add_circle_outline,
              color: isDark ? Colors.white70 : Colors.grey[700],
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesInput(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: TextField(
        controller: _notesController,
        maxLines: 3,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          hintText: 'How was your day? Any thoughts...',
          hintStyle: TextStyle(color: isDark ? Colors.white50 : Colors.grey[500]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildSaveButton(MoodProvider moodProvider, bool isDark, bool isSmall) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: moodProvider.isLoading
            ? null
            : () async {
                final success = await moodProvider.addMoodEntry(
                  moodScore: _selectedMood,
                  stressLevel: _stressLevel.toInt(),
                  sleepHours: _sleepHours,
                  notes: _notesController.text,
                );

                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mood entry saved!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Reset form
                  setState(() {
                    _selectedMood = 3;
                    _stressLevel = 5.0;
                    _sleepHours = 7.0;
                    _notesController.clear();
                  });
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: isSmall ? 14 : 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: moodProvider.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'Save Entry',
                style: TextStyle(
                  fontSize: isSmall ? 16 : 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildWeeklyAveragesCard(MoodProvider moodProvider, bool isDark, bool isSmall) {
    final averages = moodProvider.weeklyAverages;
    final avgMood = averages['mood'] ?? 0.0;
    final avgStress = averages['stress'] ?? 0.0;
    final avgSleep = averages['sleep'] ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F1720)]
              : [const Color(0xFFEEF2FF), const Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Averages',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAverageItem(
                'Mood',
                avgMood.toStringAsFixed(1),
                _getMoodEmoji(avgMood),
                isDark,
              ),
              _buildAverageItem(
                'Stress',
                avgStress.toStringAsFixed(1),
                '🧠',
                isDark,
              ),
              _buildAverageItem(
                'Sleep',
                '${avgSleep.toStringAsFixed(1)}h',
                '😴',
                isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAverageItem(String label, String value, String emoji, bool isDark) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white70 : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _getMoodEmoji(double mood) {
    if (mood >= 4.5) return '😄';
    if (mood >= 3.5) return '😊';
    if (mood >= 2.5) return '😐';
    if (mood >= 1.5) return '😔';
    return '😢';
  }

  Widget _buildMoodTrendChart(MoodProvider moodProvider, bool isDark, bool isSmall) {
    final entries = moodProvider.getRecentEntries();

    if (entries.isEmpty) {
      return _buildEmptyChart(isDark, 'No mood data yet');
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Trend (Last 7 Days)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: isDark ? Colors.white50 : Colors.grey[600],
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= entries.length) return const Text('');
                        final date = entries[value.toInt()].date;
                        return Text(
                          '${date.day}/${date.month}',
                          style: TextStyle(
                            color: isDark ? Colors.white50 : Colors.grey[600],
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (entries.length - 1).toDouble(),
                minY: 0,
                maxY: 5,
                lineBarsData: [
                  LineChartBarData(
                    spots: entries.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value.moodScore.toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.blue,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepPatternChart(MoodProvider moodProvider, bool isDark, bool isSmall) {
    final entries = moodProvider.getRecentEntries();

    if (entries.isEmpty) {
      return _buildEmptyChart(isDark, 'No sleep data yet');
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Pattern (Last 7 Days)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}h',
                          style: TextStyle(
                            color: isDark ? Colors.white50 : Colors.grey[600],
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= entries.length) return const Text('');
                        final date = entries[value.toInt()].date;
                        return Text(
                          '${date.day}/${date.month}',
                          style: TextStyle(
                            color: isDark ? Colors.white50 : Colors.grey[600],
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                maxY: 12,
                barGroups: entries.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.sleepHours,
                        color: _getSleepColor(entry.value.sleepHours),
                        width: isSmall ? 12 : 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getSleepColor(double hours) {
    if (hours >= 7) return Colors.green;
    if (hours >= 5) return Colors.orange;
    return Colors.red;
  }

  Widget _buildEmptyChart(bool isDark, String message) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 40,
              color: isDark ? Colors.white30 : Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: isDark ? Colors.white50 : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
