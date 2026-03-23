import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

/// Service to manage speech-to-text functionality.
/// Handles initialization, listening lifecycle, and permission management.
class SpeechService {
  final SpeechToText _speech = SpeechToText();
  
  bool _isAvailable = false;
  bool _isListening = false;
  String _lastError = '';

  /// Whether speech recognition is available on this device.
  bool get isAvailable => _isAvailable;
  
  /// Whether the service is currently listening.
  bool get isListening => _isListening;
  
  /// Last error message, if any.
  String get lastError => _lastError;

  /// Initialize the speech recognition service.
  /// Returns true if initialization was successful and permissions granted.
  Future<bool> initialize() async {
    try {
      _isAvailable = await _speech.initialize(
        onError: _onError,
        onStatus: _onStatus,
      );
      return _isAvailable;
    } catch (e) {
      _lastError = 'Failed to initialize speech recognition: $e';
      _isAvailable = false;
      return false;
    }
  }

  /// Start listening for speech input.
  /// [onResult] is called whenever speech is recognized.
  /// [onListeningStateChanged] is called when listening state changes.
  /// [localeId] optional locale for better recognition (e.g., 'en_US', 'hi_IN').
  Future<void> startListening({
    required Function(String text, bool isFinal) onResult,
    Function(bool isListening)? onListeningStateChanged,
    String? localeId,
  }) async {
    if (!_isAvailable) {
      _lastError = 'Speech recognition not available';
      return;
    }

    _isListening = true;
    onListeningStateChanged?.call(true);

    // Use dictation mode for continuous speech with better accuracy
    // Increased pause duration to allow natural pauses in speech
    await _speech.listen(
      onResult: (SpeechRecognitionResult result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      listenFor: const Duration(seconds: 60),  // Longer listening window
      pauseFor: const Duration(seconds: 5),    // Wait longer before stopping
      listenOptions: SpeechListenOptions(
        partialResults: true,
        listenMode: ListenMode.dictation,       // Best for continuous speech
        cancelOnError: false,                    // Don't stop on transient errors
        autoPunctuation: true,
      ),
      localeId: localeId,                       // Use specified locale
      onSoundLevelChange: null,                 // Reduce processing overhead
    );
  }

  /// Get available locales for speech recognition.
  Future<List<LocaleName>> getAvailableLocales() async {
    if (!_isAvailable) return [];
    return await _speech.locales();
  }

  /// Get the current system locale for speech.
  Future<String?> getSystemLocale() async {
    if (!_isAvailable) return null;
    final locale = await _speech.systemLocale();
    return locale?.localeId;
  }

  /// Stop listening for speech input.
  Future<void> stopListening() async {
    _isListening = false;
    await _speech.stop();
  }

  /// Cancel current listening session.
  Future<void> cancel() async {
    _isListening = false;
    await _speech.cancel();
  }

  void _onError(SpeechRecognitionError error) {
    _lastError = error.errorMsg;
    _isListening = false;
  }

  void _onStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      _isListening = false;
    }
  }
}
