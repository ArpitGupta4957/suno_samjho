import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/auth_service.dart';
import '../home/main_page.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final confirm = _confirmPasswordController.text;
      if (name.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          confirm.isEmpty) {
        throw Exception('All fields required');
      }
      if (password != confirm) {
        throw Exception('Passwords do not match');
      }
      // Basic password length check (customize as needed)
      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }
      await AuthService.instance.signUp(
        email: email,
        password: password,
        name: name,
      );
      if (!mounted) return;
      if (Navigator.canPop(context)) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleGoogleOAuth() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.instance.signInWithGoogle();
      if (Navigator.canPop(context)) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      setState(
        () => _error =
            'Authentication failed: ${e.toString().replaceAll('Exception: ', '')}',
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleAppleOAuth() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.instance.signInWithApple();
      if (Navigator.canPop(context)) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      setState(
        () => _error =
            'Authentication failed: ${e.toString().replaceAll('Exception: ', '')}',
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 64,
              vertical: isSmallScreen ? 16 : 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: isSmallScreen ? 32 : 48,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  'Name',
                  false,
                  isSmallScreen,
                  svgAsset: 'assets/profile.svg',
                  controller: _nameController,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Email',
                  false,
                  isSmallScreen,
                  svgAsset: 'assets/mail.svg',
                  controller: _emailController,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Password',
                  true,
                  isSmallScreen,
                  svgAsset: 'assets/password.svg',
                  controller: _passwordController,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Confirm Password',
                  true,
                  isSmallScreen,
                  svgAsset: 'assets/password.svg',
                  controller: _confirmPasswordController,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E242E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _loading ? null : _handleSignup,
                  child: _loading
                      ? const SizedBox(
                          height: 26,
                          width: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Sign Up',
                          style: TextStyle(
                            color: const Color(0xFFD4D4D4),
                            fontSize: isSmallScreen ? 18 : 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Or',
                        style: TextStyle(
                          color: const Color(0xFF040607),
                          fontSize: isSmallScreen ? 14 : 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSocialButton(
                  'Sign in with Google',
                  svgAsset: 'assets/googleLogo.svg',
                  isSmallScreen: isSmallScreen,
                  onPressed: _loading ? null : _handleGoogleOAuth,
                ),
                const SizedBox(height: 8),
                _buildSocialButton(
                  'Sign in with Apple',
                  svgAsset: 'assets/appleLogo.svg',
                  isSmallScreen: isSmallScreen,
                  onPressed: _loading ? null : _handleAppleOAuth,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: isSmallScreen ? 14 : 16,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          color: const Color(0xFF07090A),
                          fontSize: isSmallScreen ? 14 : 16,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    bool obscure,
    bool isSmallScreen, {
    String? svgAsset,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: svgAsset != null
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(svgAsset, width: 20, height: 20),
              )
            : null,
        labelText: label,
        labelStyle: TextStyle(
          color: const Color(0xFF040607),
          fontSize: isSmallScreen ? 16 : 20,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    String text, {
    required String svgAsset,
    required bool isSmallScreen,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        minimumSize: const Size.fromHeight(48),
        side: const BorderSide(color: Color(0xFFD9D9D9)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      onPressed: onPressed,
      icon: SvgPicture.asset(svgAsset, width: 24, height: 24),
      label: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF040607),
          fontSize: isSmallScreen ? 14 : 16,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
      ),
    );
  }
}
