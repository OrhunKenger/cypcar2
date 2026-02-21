import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/inputs/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _termsAccepted = false;
  bool _termsError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    final formValid = _formKey.currentState!.validate();
    if (!_termsAccepted) {
      setState(() => _termsError = true);
    }
    if (!formValid || !_termsAccepted) return;
    setState(() => _isLoading = true);
    // TODO: Call register use case
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLG),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppConstants.paddingXL),
            _buildHint(),
            const SizedBox(height: AppConstants.paddingXL),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Ad',
                    controller: _nameController,
                    prefixIconData: Icons.person_outlined,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Ad giriniz';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSM),
                Expanded(
                  child: CustomTextField(
                    label: 'Soyad',
                    controller: _surnameController,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Soyad giriniz';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMD),
            CustomTextField(
              label: 'E-posta',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIconData: Icons.email_outlined,
              validator: (v) {
                if (v == null || v.isEmpty) return 'E-posta giriniz';
                if (!v.contains('@')) return 'Geçerli bir e-posta giriniz';
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingMD),
            CustomTextField(
              label: 'Şifre',
              controller: _passwordController,
              isPassword: true,
              prefixIconData: Icons.lock_outlined,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Şifre giriniz';
                if (v.length < 6) return 'Şifre en az 6 karakter olmalıdır';
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingMD),
            CustomTextField(
              label: 'Şifre Tekrar',
              controller: _confirmPasswordController,
              isPassword: true,
              prefixIconData: Icons.lock_outlined,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _onRegister(),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Şifre tekrarını giriniz';
                if (v != _passwordController.text) return 'Şifreler eşleşmiyor';
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingLG),
            _buildTermsCheckbox(),
            const SizedBox(height: AppConstants.paddingLG),
            CustomButton(
              text: 'KAYIT OL',
              onPressed: _onRegister,
              isLoading: _isLoading,
            ),
            const SizedBox(height: AppConstants.paddingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildHint() {
    return Text(
      'Hesap oluşturmak için bilgilerinizi girin',
      style: GoogleFonts.raleway(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: AppColors.textMuted,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _termsAccepted,
                onChanged: (v) => setState(() {
                  _termsAccepted = v ?? false;
                  if (_termsAccepted) _termsError = false;
                }),
                activeColor: AppColors.red,
                checkColor: AppColors.textPrimary,
                side: BorderSide(
                  color: _termsError ? AppColors.error : AppColors.textMuted,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(width: AppConstants.paddingSM),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.raleway(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'Okudum ve '),
                    TextSpan(
                      text: 'Kullanım Koşulları',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.red,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.red,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // TODO: Open terms page
                        },
                    ),
                    const TextSpan(text: ' ile '),
                    TextSpan(
                      text: 'Gizlilik Politikasını',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.red,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.red,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // TODO: Open privacy page
                        },
                    ),
                    const TextSpan(text: ' kabul ediyorum.'),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (_termsError) ...[
          const SizedBox(height: AppConstants.paddingXS),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              'Devam etmek için koşulları kabul etmelisiniz',
              style: GoogleFonts.raleway(
                fontSize: 11,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
