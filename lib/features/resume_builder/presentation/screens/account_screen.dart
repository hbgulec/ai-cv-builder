import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/soft_glass_shell.dart';
import '../../data/services/supabase_account_service.dart';
import '../providers/resume_provider.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final _emailController = TextEditingController();
  bool _isSending = false;
  bool _useExistingAccount = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    if (!email.contains('@')) {
      _showMessage('Geçerli bir e-posta adresi girin.');
      return;
    }

    setState(() => _isSending = true);
    try {
      final service = ref.read(supabaseAccountServiceProvider);
      if (_useExistingAccount) {
        await service.sendSignInLink(email);
      } else {
        await service.connectGuestEmail(email);
      }
      if (!mounted) {
        return;
      }
      _showMessage(
        'Doğrulama bağlantısını e-posta adresinize gönderdik. Bağlantıyı bu cihazda açın.',
      );
    } on AuthException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    } catch (_) {
      if (mounted) {
        _showMessage('Bağlantı gönderilemedi. Lütfen tekrar deneyin.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(supabaseAccountServiceProvider);
    final user = service.currentUser;
    final isGuest = service.isAnonymous;
    final isPro = ref.watch(isProUserProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SoftGlassBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Hesabınız',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'CV verileriniz yalnızca hesabınıza bağlı olarak saklanır.',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 24),
                GlassCard(
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isGuest
                              ? Icons.person_outline_rounded
                              : Icons.verified_user_outlined,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isGuest ? 'Misafir çalışma alanı' : 'Bağlı hesap',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              isGuest
                                  ? 'Verilerinizi e-postanızla kalıcı hale getirin.'
                                  : (user?.email ??
                                      'E-posta doğrulaması bekleniyor'),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (kDebugMode) ...[
                  const SizedBox(height: 16),
                  GlassCard(
                    showShadow: false,
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: isPro,
                      onChanged: (value) =>
                          ref.read(isProUserProvider.notifier).state = value,
                      title: const Text(
                        'Developer Tools: PRO test erişimi',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        'Yalnızca debug derlemelerde görünür. PRO şablonları ve akışlarını test etmek için kullanın.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                      secondary: const Icon(
                        Icons.developer_mode_outlined,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
                ],
                if (isGuest || _useExistingAccount) ...[
                  const SizedBox(height: 16),
                  GlassCard(
                    showShadow: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _useExistingAccount
                              ? 'E-posta ile giriş yapın'
                              : 'Misafir verilerinizi koruyun',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _useExistingAccount
                              ? 'Şifresiz giriş bağlantısını e-posta adresinize göndeririz.'
                              : 'Şifre oluşturmanız gerekmez; e-posta doğrulaması mevcut misafir hesabınızı korur.',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            labelText: 'E-posta adresi',
                            prefixIcon: Icon(Icons.mail_outline_rounded),
                          ),
                        ),
                        const SizedBox(height: 12),
                        AppButton(
                          text: _useExistingAccount
                              ? 'Giriş bağlantısı gönder'
                              : 'E-posta ile devam et',
                          icon: Icons.arrow_forward_rounded,
                          isFullWidth: true,
                          isLoading: _isSending,
                          onPressed: _isSending ? null : _submit,
                        ),
                      ],
                    ),
                  ),
                ],
                if (isGuest && !_useExistingAccount)
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          setState(() => _useExistingAccount = true),
                      child: const Text(
                          'Zaten hesabınız var mı? E-posta ile giriş yapın'),
                    ),
                  ),
                const Spacer(),
                const Center(
                  child: Text(
                    'Şifre saklamıyoruz. E-posta bağlantısı yalnızca bu cihazda açılmalıdır.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SoftGlassDock(
        selectedIndex: 3,
        onCreate: () => context.push('/editor'),
        onDestinationSelected: (index) {
          if (index == 0) context.go('/');
          if (index == 2) context.push('/template-select');
        },
      ),
    );
  }
}
