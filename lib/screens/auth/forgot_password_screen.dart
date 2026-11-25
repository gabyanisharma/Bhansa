import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  void _onSendLink() {
    if (_formKey.currentState!.validate()) {
      // TODO: connect to AuthService (backend step)
      debugPrint('Reset link to: ${_emailController.text.trim()}');
      setState(() => _emailSent = true);
    }
  }

  void _onBackToLogin() {
    Navigator.pop(context);
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: AppColors.hint, fontSize: 14),
      prefixIcon: Icon(icon, color: AppColors.textGrey, size: 20),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      enabledBorder: border(AppColors.border),
      focusedBorder: border(AppColors.orange),
      errorBorder: border(Colors.red),
      focusedErrorBorder: border(Colors.red),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset('assets/logo.png', fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bhansa',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green,
                    height: 1.1,
                  ),
                ),
                Text(
                  'भान्सा',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.orangeDark,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome to your smarter kitchen.',
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey),
        ),
        const SizedBox(height: 16),
        const Divider(color: AppColors.border, height: 1),
      ],
    );
  }

  Widget _primaryButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // ---------- Form view ----------
  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FORGOT PASSWORD',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppColors.orangeDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Reset your password',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Enter the email linked to your account and we'll send you a link to reset your password.",
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textGrey),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Email address',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: _validateEmail,
            onFieldSubmitted: (_) => _onSendLink(),
            decoration: _inputDecoration(
              hint: 'you@example.com',
              icon: Icons.mail_outline,
            ),
          ),
          const SizedBox(height: 28),
          _primaryButton('Send reset link', _onSendLink),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Remembered it? ',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              ),
              GestureDetector(
                onTap: _onBackToLogin,
                child: Text(
                  'Back to sign in',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Success view ----------
  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_outlined,
              size: 40,
              color: AppColors.orangeDark,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(
            'Check your email',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppColors.green,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text.rich(
            TextSpan(
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textGrey,
                height: 1.5,
              ),
              children: [
                const TextSpan(text: "We've sent a password reset link to\n"),
                TextSpan(
                  text: _emailController.text.trim(),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),
        _primaryButton('Back to sign in', _onBackToLogin),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't get it? ",
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textGrey,
              ),
            ),
            GestureDetector(
              onTap: _onSendLink,
              child: Text(
                'Resend',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.green,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _buildHeader(),
              const SizedBox(height: 32),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _emailSent
                    ? KeyedSubtree(
                  key: const ValueKey('success'),
                  child: _buildSuccessView(),
                )
                    : KeyedSubtree(
                  key: const ValueKey('form'),
                  child: _buildFormView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}