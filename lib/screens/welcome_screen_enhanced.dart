import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'auth/login_screen.dart'; // ✅ FIXED - Removed ../
import 'auth/signup_screen.dart'; // ✅ FIXED - Removed ../
import '../utils/theme.dart';

class WelcomeScreenEnhanced extends StatefulWidget {
  const WelcomeScreenEnhanced({super.key});

  @override
  State<WelcomeScreenEnhanced> createState() => _WelcomeScreenEnhancedState();
}

class _WelcomeScreenEnhancedState extends State<WelcomeScreenEnhanced>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  late AnimationController _animationController;

  final List<FeatureItem> _features = [
    FeatureItem(
      icon: Icons.explore,
      title: 'Explore Clubs',
      subtitle: 'Real-time Events',
    ),
    FeatureItem(
      icon: Icons.event_available,
      title: 'Real-time Events',
      subtitle: 'Stay Updated',
    ),
    FeatureItem(
      icon: Icons.chat_bubble,
      title: 'Stay Connected',
      subtitle: 'Community Engagement',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: AnimatedWavePainter(
                  animationValue: _animationController.value,
                ),
              );
            },
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Logo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    'ClubHub',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Feature showcase card
                Container(
                  height: 160,
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _features.asMap().entries.map((entry) {
                      return _buildFeatureIcon(entry.value);
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // Carousel dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => _buildDot(index),
                  ),
                ),

                const Spacer(),

                // Action buttons card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Join the Hub!',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              text: 'Login',
                              isPrimary: true,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildActionButton(
                              text: 'Sign Up',
                              isPrimary: false,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignupScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(FeatureItem feature) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            feature.icon,
            size: 32,
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          feature.title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: _currentPage == index ? 32 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? AppTheme.primaryOrange
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? AppTheme.primaryOrange : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isPrimary
              ? null
              : Border.all(
                  color: AppTheme.primaryOrange,
                  width: 2,
                ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppTheme.primaryOrange.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isPrimary ? Colors.white : AppTheme.primaryOrange,
          ),
        ),
      ),
    );
  }
}

class FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;

  FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

// Animated wave painter with organic blob shapes
class AnimatedWavePainter extends CustomPainter {
  final double animationValue;

  AnimatedWavePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.primaryBlue,
          AppTheme.primaryBlue.withOpacity(0.8),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Top blob
    final topPath = Path();
    topPath.moveTo(0, 0);
    topPath.lineTo(0, size.height * 0.35);

    final cp1X = size.width * 0.3;
    final cp1Y =
        size.height * 0.25 + math.sin(animationValue * 2 * math.pi) * 20;
    final cp2X = size.width * 0.7;
    final cp2Y =
        size.height * 0.35 + math.cos(animationValue * 2 * math.pi) * 20;

    topPath.cubicTo(
      cp1X,
      cp1Y,
      cp2X,
      cp2Y,
      size.width,
      size.height * 0.3,
    );
    topPath.lineTo(size.width, 0);
    topPath.close();

    canvas.drawPath(topPath, paint);

    // Bottom blob
    final bottomPath = Path();
    bottomPath.moveTo(0, size.height);
    bottomPath.lineTo(0, size.height * 0.75);

    final cp3X = size.width * 0.4;
    final cp3Y =
        size.height * 0.8 + math.sin(animationValue * 2 * math.pi + 1) * 20;
    final cp4X = size.width * 0.8;
    final cp4Y =
        size.height * 0.7 + math.cos(animationValue * 2 * math.pi + 1) * 20;

    bottomPath.cubicTo(
      cp3X,
      cp3Y,
      cp4X,
      cp4Y,
      size.width,
      size.height * 0.8,
    );
    bottomPath.lineTo(size.width, size.height);
    bottomPath.close();

    canvas.drawPath(bottomPath, paint);

    // Background color
    final bgPaint = Paint()
      ..color = const Color(0xFFE8EAD8)
      ..style = PaintingStyle.fill;

    final bgPath = Path();
    bgPath.moveTo(0, size.height * 0.35);
    bgPath.lineTo(0, size.height * 0.75);
    bgPath.cubicTo(
      cp3X,
      cp3Y,
      cp4X,
      cp4Y,
      size.width,
      size.height * 0.8,
    );
    bgPath.lineTo(size.width, size.height * 0.3);
    bgPath.cubicTo(
      cp2X,
      cp2Y,
      cp1X,
      cp1Y,
      0,
      size.height * 0.35,
    );
    bgPath.close();

    canvas.drawPath(bgPath, bgPaint);
  }

  @override
  bool shouldRepaint(AnimatedWavePainter oldDelegate) =>
      animationValue != oldDelegate.animationValue;
}
