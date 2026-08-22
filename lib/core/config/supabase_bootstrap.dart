import 'package:supabase_flutter/supabase_flutter.dart';

/// Reads only compile-time values so credentials never enter source control.
class SupabaseConfig {
  const SupabaseConfig._();

  static const url = String.fromEnvironment('SUPABASE_URL');
  static const publishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  static bool get isConfigured =>
      Uri.tryParse(url)?.hasScheme == true && publishableKey.isNotEmpty;
}

class SupabaseBootstrap {
  const SupabaseBootstrap._();

  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    if (!SupabaseConfig.isConfigured) {
      return;
    }

    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
    _isInitialized = true;
  }
}
