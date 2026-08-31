import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/link_launcher.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../widgets/app_buttons.dart';
import '../widgets/fade_in_on_scroll.dart';
import '../widgets/social_pill.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.onContactPressed});

  final VoidCallback onContactPressed;

  @override
  Widget build(BuildContext context) {
    final nameSize = context.responsive<double>(
      mobile: 42,
      tablet: 62,
      desktop: 78,
    );
    final roleSize = context.responsive<double>(
      mobile: 26,
      tablet: 40,
      desktop: 52,
    );

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.sizeOf(context).height * 0.92,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalPadding,
        vertical: 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.maxContentWidth,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInOnScroll(
                child: Text(
                  'Hi, my name is',
                  style: AppTheme.mono(size: context.isMobile ? 14 : 17),
                ),
              ),
              const SizedBox(height: 22),
              FadeInOnScroll(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  '${PortfolioData.name}.',
                  style: TextStyle(
                    fontSize: nameSize,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.05,
                    letterSpacing: -2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeInOnScroll(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  'I build mobile apps.',
                  style: TextStyle(
                    fontSize: roleSize,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                    height: 1.1,
                    letterSpacing: -1.5,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              FadeInOnScroll(
                delay: const Duration(milliseconds: 300),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Text(
                    "I'm a ${PortfolioData.role} based in ${PortfolioData.location}, "
                    'specializing in building high-quality mobile experiences '
                    'with Flutter — from real-time video calling to '
                    'production e-commerce and delivery platforms.',
                    style: TextStyle(
                      fontSize: context.isMobile ? 16 : 18,
                      color: AppColors.textSecondary,
                      height: 1.75,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 44),
              FadeInOnScroll(
                delay: const Duration(milliseconds: 400),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    AccentButton(
                      label: 'Download CV',
                      icon: Icons.download_rounded,
                      filled: true,
                      onPressed: LinkLauncher.downloadCv,
                    ),
                    AccentButton(
                      label: 'Get In Touch',
                      icon: Icons.mail_outline_rounded,
                      onPressed: onContactPressed,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              FadeInOnScroll(
                delay: const Duration(milliseconds: 500),
                child: const ContactBar(compact: true),
              ),
              SizedBox(height: context.isMobile ? 56 : 80),
              FadeInOnScroll(
                delay: const Duration(milliseconds: 600),
                child: const _StatsRow(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.isMobile ? 28 : 56,
      runSpacing: 24,
      children: [
        for (final stat in PortfolioData.stats)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                stat.value,
                style: TextStyle(
                  fontSize: context.isMobile ? 30 : 38,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accent,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stat.label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
