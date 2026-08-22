import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/supabase_bootstrap.dart';

class SupabaseAccountService {
  static const _emailRedirectUrl = 'aicvbuilder://login-callback';

  bool get isConfigured => SupabaseBootstrap.isInitialized;

  User? get currentUser =>
      isConfigured ? Supabase.instance.client.auth.currentUser : null;

  bool get isAnonymous => currentUser?.isAnonymous ?? false;

  Future<void> connectGuestEmail(String email) async {
    final auth = _auth;
    final user = await _ensureUser();
    if (!user.isAnonymous) {
      await sendSignInLink(email);
      return;
    }

    await auth.updateUser(
      UserAttributes(email: email),
      emailRedirectTo: _emailRedirectUrl,
    );
  }

  Future<void> sendSignInLink(String email) async {
    await _auth.signInWithOtp(
      email: email,
      emailRedirectTo: _emailRedirectUrl,
      shouldCreateUser: false,
    );
  }

  GoTrueClient get _auth {
    if (!isConfigured) {
      throw StateError('Supabase is not configured for this build.');
    }
    return Supabase.instance.client.auth;
  }

  Future<User> _ensureUser() async {
    final auth = _auth;
    final user = auth.currentUser;
    if (user != null) {
      return user;
    }

    final response = await auth.signInAnonymously();
    final anonymousUser = response.user;
    if (anonymousUser == null) {
      throw const AuthException('Anonymous sign-in did not return a user.');
    }
    return anonymousUser;
  }
}

final supabaseAccountServiceProvider = Provider<SupabaseAccountService>((ref) {
  return SupabaseAccountService();
});
