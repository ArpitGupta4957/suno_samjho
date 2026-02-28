import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service for handling chatbot API communication with FastAPI backend.
///
/// This service sends user messages to the FastAPI endpoint and receives
/// bot responses. It follows the same error handling pattern as AuthService.
class ChatService {
  ChatService._();
  static final ChatService instance = ChatService._();

  // Base URL for FastAPI - loaded from environment variables
  String get _baseUrl => dotenv.env['FASTAPI_URL'] ?? 'http://localhost:8000';

  /// Sends a message to the FastAPI chatbot endpoint and returns the response.
  ///
  /// [message] - The user's input message
  /// [context] - Optional conversation context for multi-turn conversations
  ///
  /// Returns a [ChatResponse] containing the bot's reply or throws an exception on failure.
  Future<ChatResponse> sendMessage({
    required String message,
    List<Map<String, String>>? context,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/chat');
      
      // Prepare the request body
      final body = json.encode({
        'message': message,
        if (context != null) 'context': context,
      });

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          // Add authorization header if needed
          // 'Authorization': 'Bearer $token',
        },
        body: body,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timed out. Please check your connection.');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ChatResponse.fromJson(data);
      } else if (response.statusCode >= 500) {
        throw Exception('Server error. Please try again later.');
      } else if (response.statusCode == 404) {
        throw Exception('Chat service not found. Please check the API URL.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['detail'] ?? 'Failed to get response from chat service.');
      }
    } on FormatException {
      throw Exception('Invalid response format from server.');
    } catch (e) {
      // Re-throw if it's already our exception
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      // Handle network errors
      print('Network error during chat: $e');
      throw Exception('Unable to connect to chat service. Please check your internet connection.');
    }
  }

  /// Streams responses from the FastAPI endpoint (for streaming mode).
  ///
  /// This is an alternative to polling - yields chunks of the response as they arrive.
  Stream<String> streamMessage({
    required String message,
    List<Map<String, String>>? context,
  }) async* {
    try {
      final uri = Uri.parse('$_baseUrl/chat/stream');
      
      final body = json.encode({
        'message': message,
        if (context != null) 'context': context,
      });

      final client = http.Client();
      final request = http.Request('POST', uri)
        ..headers['Content-Type'] = 'application/json'
        ..body = body;

      final response = await client.send(request);

      if (response.statusCode == 200) {
        await for (final chunk in response.stream.transform(utf8.decoder)) {
          yield chunk;
        }
      } else if (response.statusCode >= 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception('Failed to get streaming response.');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Unable to connect to streaming service. Please check your internet connection.');
    }
  }

  /// Checks if the FastAPI service is available and healthy.
  Future<bool> checkHealth() async {
    try {
      final uri = Uri.parse('$_baseUrl/health');
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
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
