import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
                  'Sign up',
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
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Email',
                  false,
                  isSmallScreen,
                  svgAsset: 'assets/mail.svg',
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Password',
                  true,
                  isSmallScreen,
                  svgAsset: 'assets/password.svg',
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E242E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Sign In',
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
                ),
                const SizedBox(height: 8),
                _buildSocialButton(
                  'Sign in with Apple',
                  svgAsset: 'assets/appleLogo.svg',
                  isSmallScreen: isSmallScreen,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account ?',
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
                        Navigator.of(context).push(
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
  }) {
    return TextField(
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
      onPressed: () {},
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
