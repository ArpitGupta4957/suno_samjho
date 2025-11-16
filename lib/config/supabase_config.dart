// supabase_config.dart
// Loads Supabase credentials supplied via .env using flutter_dotenv.
// The .env file must define SUPABASE_URL and SUPABASE_ANON_KEY.
// Ensure .env is NOT committed (already ignored).

import 'package:flutter_dotenv/flutter_dotenv.dart';

String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
