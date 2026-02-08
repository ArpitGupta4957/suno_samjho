import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, paused, stopped }

class TtsService {
  static final TtsService _instance = TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  TtsState _ttsState = TtsState.stopped;
  String? _currentlyPlayingId;

  factory TtsService() {
    return _instance;
  }

  TtsService._internal();

  Future<void> init() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);

    _flutterTts.setCompletionHandler(() {
      _ttsState = TtsState.stopped;
      _currentlyPlayingId = null;
    });

    _flutterTts.setErrorHandler((message) {
      _ttsState = TtsState.stopped;
      _currentlyPlayingId = null;
    });
  }

  Future<void> speak(String text, String messageId) async {
    try {
      if (_currentlyPlayingId != null && _currentlyPlayingId != messageId) {
        await stop();
      }

      _currentlyPlayingId = messageId;
      _ttsState = TtsState.playing;
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error speaking: $e');
      _ttsState = TtsState.stopped;
    }
  }

  Future<void> pause() async {
    try {
      await _flutterTts.pause();
      _ttsState = TtsState.paused;
    } catch (e) {
      print('Error pausing: $e');
    }
  }

  Future<void> resume() async {
    try {
      await _flutterTts.resume();
      _ttsState = TtsState.playing;
    } catch (e) {
      print('Error resuming: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      _ttsState = TtsState.stopped;
      _currentlyPlayingId = null;
    } catch (e) {
      print('Error stopping: $e');
    }
  }

  TtsState getState() => _ttsState;

  String? getCurrentlyPlayingId() => _currentlyPlayingId;

  bool isPlaying(String messageId) =>
      _currentlyPlayingId == messageId && _ttsState == TtsState.playing;

  bool isPaused(String messageId) =>
      _currentlyPlayingId == messageId && _ttsState == TtsState.paused;
}
