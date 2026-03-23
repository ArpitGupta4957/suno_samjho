import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../config/samjho_system_prompt.dart';

/// Service for handling chatbot API communication with Google Generative AI (Gemini).
///
/// This service sends user messages to the Gemini API and receives responses
/// from "Samjho", the compassionate mental health support companion.
class ChatService {
  ChatService._();
  static final ChatService instance = ChatService._();

  // Gemini API configuration
  String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  String get _model => dotenv.env['GEMINI_MODEL'] ?? 'gemini-2.5-flash';

  // Gemini API endpoint
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  // Track conversation history for multi-turn context
  final List<Map<String, dynamic>> _conversationHistory = [];

  /// Sends a message to the Gemini API and returns the response.
  ///
  /// [message] - The user's input message
  /// [context] - Optional conversation context (currently uses internal history)
  ///
  /// Returns a [ChatResponse] containing the bot's reply or throws an exception on failure.
  Future<ChatResponse> sendMessage({
    required String message,
    List<Map<String, String>>? context,
  }) async {
    try {
      // Add user message to conversation history
      _conversationHistory.add({
        'role': 'user',
        'parts': [
          {'text': message},
        ],
      });

      // Build request to Gemini API
      final uri = Uri.parse('$_baseUrl/$_model:generateContent?key=$_apiKey');

      // Prepare messages for the API
      final List<Map<String, dynamic>> contents = [];

      // Add system prompt instructions (prepend to first call)
      if (_conversationHistory.length == 1) {
        contents.add({
          'role': 'user',
          'parts': [
            {
              'text':
                  'You are Samjho. ' +
                  SamjhoSystemPrompt.mainPrompt
                      .replaceAll('\n', ' ')
                      .replaceAll('  ', ' ')
                      .trim(),
            },
          ],
        });
        contents.add({
          'role': 'model',
          'parts': [
            {
              'text':
                  'I understand. I am Samjho, a compassionate mental health support companion. I am ready to listen and support you with warmth and empathy. 💙',
            },
          ],
        });
      }

      // Add conversation history
      for (final msg in _conversationHistory) {
        contents.add(msg);
      }

      final requestBody = {
        'contents': contents,
        'generationConfig': {
          'temperature': 0.7,
          'topP': 0.95,
          'maxOutputTokens': 250,
        },
      };

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestBody),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception(
                'Request timed out. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extract the bot response
        final candidates = data['candidates'] as List?;
        if (candidates == null || candidates.isEmpty) {
          throw Exception('No response from Gemini API.');
        }

        final firstCandidate = candidates[0] as Map<String, dynamic>;
        final content = firstCandidate['content'] as Map<String, dynamic>?;
        if (content == null) {
          throw Exception('Invalid response format from Gemini API.');
        }

        final parts = content['parts'] as List?;
        if (parts == null || parts.isEmpty) {
          throw Exception('No text in Gemini response.');
        }

        final botMessage = (parts[0] as Map<String, dynamic>)['text'] as String;

        // Add bot response to history
        _conversationHistory.add({
          'role': 'model',
          'parts': [
            {'text': botMessage},
          ],
        });

        return ChatResponse(
          message: botMessage,
          crisisFlag: _checkCrisisKeywords(message),
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          'Authentication failed. Please check your Gemini API key.',
        );
      } else if (response.statusCode == 429) {
        throw Exception(
          'Too many requests. Please wait a moment and try again.',
        );
      } else if (response.statusCode >= 500) {
        throw Exception('Gemini API server error. Please try again later.');
      } else {
        final errorData = json.decode(response.body);
        final error = errorData['error'] as Map<String, dynamic>?;
        throw Exception(
          error?['message'] ?? 'Failed to get response from Gemini.',
        );
      }
    } on FormatException {
      throw Exception('Invalid response format from Gemini API.');
    } catch (e) {
      // Re-throw if it's already our exception
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      print('Error in chat service: $e');
      throw Exception(
        'Unable to connect to the chat service. Please check your internet connection.',
      );
    }
  }

  /// Checks if the message contains crisis-related keywords
  bool _checkCrisisKeywords(String message) {
    final lowerMessage = message.toLowerCase();
    for (final keyword in SamjhoSystemPrompt.safetyConcernKeywords) {
      if (lowerMessage.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  /// Clears conversation history (useful for starting a new session)
  void clearHistory() {
    _conversationHistory.clear();
  }

  /// Returns the current conversation history length
  int get historyLength => _conversationHistory.length;
}

/// Data class representing a chat response from the API.
class ChatResponse {
  final String message;
  final String? sessionId;
  final Map<String, dynamic>? metadata;
  final bool crisisFlag;

  ChatResponse({
    required this.message,
    this.sessionId,
    this.metadata,
    this.crisisFlag = false,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      message: json['message'] as String? ?? json['response'] as String? ?? '',
      sessionId: json['session_id'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      crisisFlag: json['crisis_flag'] as bool? ?? false,
    );
  }
}
