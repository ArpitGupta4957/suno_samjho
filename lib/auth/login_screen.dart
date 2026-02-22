import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../home/main_page.dart';
import '../services/auth_service.dart';
import '../utils/input_validator.dart';
import '../utils/auth_error_handler.dart';
import '../config/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _showSignUp = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Field-specific errors for real-time validation
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    // Add listeners for real-time validation
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }
  
  void _validateEmail() {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        _emailError = InputValidator.validateEmail(_emailController.text);
      });
    } else {
      setState(() => _emailError = null);
    }
  }
  
  void _validatePassword() {
    if (_passwordController.text.isNotEmpty) {
      setState(() {
        _passwordError = InputValidator.validatePassword(_passwordController.text);
      });
    } else {
      setState(() => _passwordError = null);
    }
    // Also validate confirm password if it has content
    if (_confirmPasswordController.text.isNotEmpty) {
      _validateConfirmPassword();
    }
  }
  
  void _validateConfirmPassword() {
    if (_confirmPasswordController.text.isNotEmpty) {
      setState(() {
        _confirmPasswordError = InputValidator.validateConfirmPassword(
          _passwordController.text,
          _confirmPasswordController.text,
        );
      });
    } else {
      setState(() => _confirmPasswordError = null);
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateEmail);
    _passwordController.removeListener(_validatePassword);
    _confirmPasswordController.removeListener(_validateConfirmPassword);
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    setState(() {
      _loading = true;
      _error = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });
    
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    bool hasError = false;
    
    // Email validation
    final emailError = InputValidator.validateEmail(email);
    if (emailError != null) {
      setState(() => _emailError = emailError);
      hasError = true;
    }
    
    // Password validation
    final passwordError = InputValidator.validatePassword(password);
    if (passwordError != null) {
      setState(() => _passwordError = passwordError);
      hasError = true;
    }
    
    // Confirm password validation (only for signup)
    if (_showSignUp) {
      final confirmError = InputValidator.validateConfirmPassword(password, confirmPassword);
      if (confirmError != null) {
        setState(() => _confirmPasswordError = confirmError);
        hasError = true;
      }
    }
    
    if (hasError) {
      setState(() => _loading = false);
      return;
    }
    
    try {
      if (_showSignUp) {
        await AuthService.instance.signUp(email: email, password: password);
      } else {
        await AuthService.instance.signIn(email: email, password: password);
      }
      if (!mounted) return;
      if (Navigator.canPop(context)) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      print('Login error caught: $e');
      final message = e.toString().replaceAll('Exception: ', '');
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
      setState(() => _error = 'Authentication failed: ${e.toString().replaceAll('Exception: ', '')}');
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
      setState(() => _error = 'Authentication failed: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.getDarkCardColor() : Colors.white,
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
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: isSmallScreen ? 32 : 48,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTextField('Email', false, isSmallScreen, isDark: isDark),
                const SizedBox(height: 12),
                _buildTextField('Password', true, isSmallScreen, isDark: isDark, isPassword: true, obscureText: _obscurePassword, onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword)),
                if (_showSignUp) ...[
                  const SizedBox(height: 12),
                  _buildTextField('Confirm Password', true, isSmallScreen, isDark: isDark, isPassword: true, obscureText: _obscureConfirmPassword, onToggleVisibility: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_error!, style: TextStyle(color: Colors.red.shade700, fontSize: 13))),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                if (!_showSignUp)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Remember me', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF040607), fontSize: isSmallScreen ? 14 : 18, fontFamily: 'NTR', fontWeight: FontWeight.w400)),
                      Text('Forget Password', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF040607), fontSize: isSmallScreen ? 14 : 18, fontFamily: 'NTR', fontWeight: FontWeight.w400)),
                    ],
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: isDark ? Colors.grey[700]! : const Color(0xFFB6B6B6))),
                    backgroundColor: const Color(0xFF1E242E),
                    foregroundColor: const Color(0xFFD4D4D4),
                  ),
                  onPressed: _loading ? null : _handleAuth,
                  child: _loading
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(_showSignUp ? 'Create Account' : 'Login', style: TextStyle(fontSize: isSmallScreen ? 18 : 24, fontFamily: 'Inter', fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Or', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF040607), fontSize: isSmallScreen ? 16 : 20, fontFamily: 'Inter', fontWeight: FontWeight.w400))]),
                const SizedBox(height: 16),
                _buildSocialButton('Sign in with Google', isDark ? Colors.white : Colors.black, isSmallScreen: isSmallScreen, isDark: isDark, onTap: _loading ? null : _handleGoogleOAuth),
                const SizedBox(height: 8),
                _buildSocialButton('Sign in with Apple', isDark ? Colors.white : Colors.black, isSmallScreen: isSmallScreen, isDark: isDark, onTap: _loading ? null : _handleAppleOAuth),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_showSignUp ? 'Already have an account?' : 'Don\'t have an account?', style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: isSmallScreen ? 14 : 16, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.5)),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _showSignUp = !_showSignUp),
                      child: Text(_showSignUp ? 'Login' : 'Sign up', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF070809), fontSize: isSmallScreen ? 14 : 16, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.5)),
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

  Widget _buildTextField(String label, bool isPassword, bool isSmallScreen, {bool isDark = false, bool obscureText = false, VoidCallback? onToggleVisibility}) {
    String? iconAsset;
    if (label == 'Email') {
      iconAsset = 'assets/mail.svg';
    } else if (label.contains('Password')) {
      iconAsset = 'assets/password.svg';
    }
    
    final hasError = _getErrorForField(label) != null;
    final errorText = _getErrorForField(label);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          obscureText: obscureText,
          controller: _getControllerForField(label),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: isDark ? Colors.white70 : const Color(0xFF040607), fontSize: isSmallScreen ? 18 : 24, fontFamily: 'Inter', fontWeight: FontWeight.w400),
            filled: true,
            fillColor: isDark ? Colors.grey[800] : const Color(0xFFD9D9D9).withOpacity(0.15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: hasError ? Colors.red.shade400 : (isDark ? Colors.grey[700]! : const Color(0xFFD9D9D9)))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: hasError ? Colors.red.shade400 : (isDark ? Colors.grey[700]! : const Color(0xFFD9D9D9)))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: hasError ? Colors.red.shade600 : const Color(0xFF4A90E2), width: 2)),
            prefixIcon: iconAsset != null ? Padding(padding: const EdgeInsets.all(12.0), child: SvgPicture.asset(iconAsset, width: 24, height: 24, color: isDark ? Colors.white70 : null)) : null,
            suffixIcon: onToggleVisibility != null ? IconButton(icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: isDark ? Colors.white60 : Colors.grey.shade600), onPressed: onToggleVisibility) : null,
            errorText: null,
          ),
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Padding(padding: const EdgeInsets.only(left: 12), child: Text(errorText!, style: TextStyle(color: Colors.red.shade600, fontSize: 12))),
        ],
      ],
    );
  }

  String? _getErrorForField(String label) {
    if (label == 'Email') return _emailError;
    if (label == 'Password') return _passwordError;
    if (label.contains('Confirm')) return _confirmPasswordError;
    return null;
  }

  TextEditingController _getControllerForField(String label) {
    if (label == 'Email') return _emailController;
    if (label == 'Password') return _passwordController;
    return _confirmPasswordController;
  }

  Widget _buildSocialButton(String text, Color textColor, {required bool isSmallScreen, bool isDark = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(color: isDark ? Colors.grey[800] : const Color(0xFFD9D9D9).withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (text.contains('Google')) ...[
              SvgPicture.asset('assets/googleLogo.svg', width: 24, height: 24),
              const SizedBox(width: 8),
            ] else if (text.contains('Apple')) ...[
              SvgPicture.asset('assets/appleLogo.svg', width: 24, height: 24),
              const SizedBox(width: 8),
            ],
            Text(text, style: TextStyle(color: textColor, fontSize: isSmallScreen ? 14 : 16, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
