import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/inputs/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // TODO: Call login use case
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
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _onLogin(),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Şifre giriniz';
                if (v.length < 6) return 'Şifre en az 6 karakter olmalıdır';
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingSM),
            _buildForgotPassword(),
            const SizedBox(height: AppConstants.paddingXL),
            CustomButton(
              text: 'GİRİŞ YAP',
              onPressed: _onLogin,
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
      'Hesabınıza erişmek için bilgilerinizi girin',
      style: GoogleFonts.raleway(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: AppColors.textMuted,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          // TODO: Navigate to forgot password
        },
        child: Text(
          'Şifremi Unuttum',
          style: GoogleFonts.raleway(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textMuted,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
