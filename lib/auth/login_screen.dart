import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                      'Log in',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: isSmallScreen ? 32 : 48,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTextField('Email', false, isSmallScreen),
                const SizedBox(height: 12),
                _buildTextField('Password', true, isSmallScreen),
                const SizedBox(height: 8),
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
                  onPressed: () {},
                  child: Text(
                    'Login',
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
                ),
                const SizedBox(height: 8),
                _buildSocialButton(
                  'Sign in with Apple',
                  Colors.black,
                  svgAsset: 'assets/appleLogo.svg',
                  isSmallScreen: isSmallScreen,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don’t have an account ?',
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
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign up',
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

  Widget _buildTextField(String label, bool isPassword, bool isSmallScreen) {
    String? iconAsset;
    if (label == 'Email') {
      iconAsset = 'assets/mail.svg';
    } else if (label == 'Password') {
      iconAsset = 'assets/password.svg';
    }
    return TextField(
      obscureText: isPassword,
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
  }) {
    return Container(
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
    );
  }
}
