import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final SupabaseClient client = Supabase.instance.client;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: name != null ? {'name': name} : null,
    );
    return response;
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      // Log full error for debugging
      print('AuthException: ${e.message}, statusCode: ${e.statusCode}');
      final msg = e.message.toLowerCase();
      if (msg.contains('invalid') ||
          msg.contains('credential') ||
          msg.contains('password') ||
          msg.contains('email not confirmed')) {
        throw Exception('INVALID_CREDENTIALS');
      }
      throw Exception(e.message);
    } catch (e) {
      print('Unexpected error during sign in: $e');
      rethrow;
    }
  }

  Future<void> signInWithGoogle({String? redirectTo}) async {
    try {
      await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo:
            redirectTo ?? (kIsWeb ? null : 'io.supabase.flutter://callback'),
        scopes: 'email profile',
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signInWithApple({String? redirectTo}) async {
    try {
      await client.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo:
            redirectTo ?? (kIsWeb ? null : 'io.supabase.flutter://callback'),
        scopes: 'name email',
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  Session? get currentSession => client.auth.currentSession;
  User? get currentUser => client.auth.currentUser;

  String getUserName() {
    final user = currentUser;
    if (user == null) return 'Guest';
    // Try to get name from user metadata
    final metadata = user.userMetadata;
    if (metadata != null && metadata['name'] != null) {
      return metadata['name'] as String;
    }
    // Fallback to email username
    return user.email?.split('@').first ?? 'User';
  }
}
