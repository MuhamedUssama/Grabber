import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';
import 'package:grabber/core/routes/routes_name.dart';
import 'package:grabber/core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(milliseconds: 4500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, RoutesName.homeScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appName = AppLocalizations.of(context)!.appName;

    return Scaffold(
      backgroundColor: AppColors.dark,
      body: Stack(
        children: [
          // Dynamic Background Glows with Brand Palette
          Positioned(
                top: -150,
                right: -100,
                child: _GlowCircle(
                  color: AppColors.darkTextColor.withValues(alpha: 0.05),
                  size: 600,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .move(
                begin: const Offset(-40, -40),
                end: const Offset(40, 40),
                duration: 10.seconds,
                curve: Curves.easeInOut,
              )
              .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3)),

          Positioned(
                bottom: -200,
                left: -150,
                child: _GlowCircle(
                  color: AppColors.darkHeadTextColor.withValues(alpha: 0.03),
                  size: 800,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .move(
                begin: const Offset(50, 50),
                end: const Offset(-50, -50),
                duration: 15.seconds,
                curve: Curves.easeInOut,
              )
              .scale(
                begin: const Offset(1.2, 1.2),
                end: const Offset(0.8, 0.8),
              ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Main App Name with Premium Typography and Dynamic Animation
                Text(
                      appName.toUpperCase(),
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 120,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -5,
                        color: AppColors.darkTextColor,
                        height: 0.85,
                        shadows: [
                          Shadow(
                            color: AppColors.darkWithOpacity.withValues(
                              alpha: 0.8,
                            ),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 1.2.seconds)
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      curve: Curves.easeOutQuart,
                      duration: 1.2.seconds,
                    )
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                      curve: Curves.easeOutBack,
                      duration: 1.2.seconds,
                    )
                    .shimmer(
                      delay: 2.seconds,
                      duration: 2.5.seconds,
                      color: Colors.white12,
                    ),

                const SizedBox(height: 16),

                // Tagline / Subtitle
                Text(
                      "NEXT GEN DOWNLOADER",
                      style: TextStyle(
                        color: AppColors.darkHeadTextColor,
                        letterSpacing: 12,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 800.ms)
                    .blurXY(begin: 15, end: 0, delay: 800.ms)
                    .slideY(begin: 2, end: 0, delay: 800.ms),
              ],
            ),
          ),

          // Progress Indicator (Sleek line at bottom)
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 300,
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.darkWithOpacity.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Container(
                              width: 300,
                              height: 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.darkHeadTextColor,
                                    AppColors.darkTextColor,
                                    AppColors.darkHeadTextColor,
                                  ],
                                ),
                              ),
                            )
                            .animate()
                            .custom(
                              duration: 3800.ms,
                              curve: Curves.easeInOutExpo,
                              builder:
                                  (context, value, child) =>
                                      FractionallySizedBox(
                                        widthFactor: value,
                                        child: child,
                                      ),
                            )
                            .shimmer(
                              duration: 1.5.seconds,
                              color: Colors.white24,
                            ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                        "PREPARING SUBSYSTEMS",
                        style: TextStyle(
                          color: AppColors.darkHeadTextColor.withValues(
                            alpha: 0.5,
                          ),
                          fontSize: 11,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 1.5.seconds)
                      .shimmer(
                        duration: 3.seconds,
                        color: AppColors.darkTextColor.withValues(alpha: 0.3),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}
