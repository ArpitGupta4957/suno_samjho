import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../home/main_page.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _showSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email & password required');
      }
      if (_showSignUp) {
        if (_confirmPasswordController.text != password) {
          throw Exception('Passwords do not match');
        }
        await AuthService.instance.signUp(email: email, password: password);
      } else {
        await AuthService.instance.signIn(email: email, password: password);
      }
      if (!mounted) return;
      // AuthGate handles the root widget switch.
      // We need to pop any pushed routes (like Onboarding pages) to reveal Dashboard.
      if (Navigator.canPop(context)) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      print('Login error caught: $e'); // Debug log
      final raw = e.toString();
      String message;
      if (raw.contains('INVALID_CREDENTIALS')) {
        message = 'Email or password incorrect';
      } else if (raw.contains('Passwords do not match')) {
        message = 'Passwords do not match';
      } else if (raw.contains('Email & password required')) {
        message = 'Email & password required';
      } else {
        // Show actual error during development to help debug
        message = 'Authentication failed: ${raw.replaceAll('Exception: ', '')}';
      }
      setState(() => _error = message);
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
            width: isSmallScreen ? double.infinity : 400,
            padding: EdgeInsets.symmetric(
              vertical: isSmallScreen ? 24 : 32,
              horizontal: isSmallScreen ? 16 : 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _showSignUp ? 'Create Account' : 'Log in',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: isSmallScreen ? 32 : 48,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  'Email',
                  false,
                  isSmallScreen,
                  controller: _emailController,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Password',
                  true,
                  isSmallScreen,
                  controller: _passwordController,
                ),
                if (_showSignUp) ...[
                  const SizedBox(height: 12),
                  _buildTextField(
                    'Confirm Password',
                    true,
                    isSmallScreen,
                    controller: _confirmPasswordController,
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ],
                const SizedBox(height: 8),
                if (!_showSignUp)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Remember me',
                        style: TextStyle(
                          color: const Color(0xFF040607),
                          fontSize: isSmallScreen ? 14 : 18,
                          fontFamily: 'NTR',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Forget Password',
                        style: TextStyle(
                          color: const Color(0xFF040607),
                          fontSize: isSmallScreen ? 14 : 18,
                          fontFamily: 'NTR',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Color(0xFFB6B6B6)),
                    ),
                    backgroundColor: const Color(0xFF1E242E),
                    foregroundColor: const Color(0xFFD4D4D4),
                  ),
                  onPressed: _loading ? null : _handleAuth,
                  child: _loading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _showSignUp ? 'Create Account' : 'Login',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 18 : 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Or',
                      style: TextStyle(
                        color: const Color(0xFF040607),
                        fontSize: isSmallScreen ? 16 : 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSocialButton(
                  'Sign in with Google',
                  Colors.black,
                  svgAsset: 'assets/googleLogo.svg',
                  isSmallScreen: isSmallScreen,
                  onTap: _loading ? null : _handleGoogleOAuth,
                ),
                const SizedBox(height: 8),
                _buildSocialButton(
                  'Sign in with Apple',
                  Colors.black,
                  svgAsset: 'assets/appleLogo.svg',
                  isSmallScreen: isSmallScreen,
                  onTap: _loading ? null : _handleAppleOAuth,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _showSignUp
                          ? 'Already have an account?'
                          : 'Don’t have an account?',
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
                      onTap: () => setState(() => _showSignUp = !_showSignUp),
                      child: Text(
                        _showSignUp ? 'Login' : 'Sign up',
                        style: TextStyle(
                          color: const Color(0xFF070809),
                          fontSize: isSmallScreen ? 14 : 16,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                          height: 1.5,
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
    bool isPassword,
    bool isSmallScreen, {
    required TextEditingController controller,
  }) {
    String? iconAsset;
    if (label == 'Email') {
      iconAsset = 'assets/mail.svg';
    } else if (label == 'Password') {
      iconAsset = 'assets/password.svg';
    }
    return TextField(
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: const Color(0xFF040607),
          fontSize: isSmallScreen ? 18 : 24,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: const Color(0xFFD9D9D9).withOpacity(0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
        ),
        prefixIcon: iconAsset != null
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(iconAsset, width: 24, height: 24),
              )
            : null,
      ),
    );
  }

  Widget _buildSocialButton(
    String text,
    Color textColor, {
    String? svgAsset,
    required bool isSmallScreen,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9).withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (svgAsset != null) ...[
              SvgPicture.asset(svgAsset, width: 24, height: 24),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: isSmallScreen ? 14 : 16,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
