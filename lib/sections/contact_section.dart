import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/link_launcher.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../widgets/app_buttons.dart';
import '../widgets/fade_in_on_scroll.dart';
import '../widgets/social_pill.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key, this.sectionKey});

  final Key? sectionKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalPadding,
        vertical: context.sectionSpacing,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: FadeInOnScroll(
            child: Column(
              children: [
                Text('05. What\'s Next?', style: AppTheme.mono(size: 14)),
                const SizedBox(height: 22),
                Text(
                  'Get In Touch',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.responsive<double>(
                      mobile: 36,
                      tablet: 48,
                      desktop: 56,
                    ),
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 26),
                const Text(
                  'I\'m currently open to new opportunities and interesting '
                  'projects. Whether you have a question or just want to say '
                  'hello, my inbox is always open — I\'ll do my best to get '
                  'back to you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.5,
                    color: AppColors.textSecondary,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 44),
                AccentButton(
                  label: 'Say Hello',
                  icon: Icons.mail_outline_rounded,
                  filled: true,
                  onPressed: () =>
                      LinkLauncher.open('mailto:${PortfolioData.email}'),
                ),
                const SizedBox(height: 56),
                const ContactBar(alignment: WrapAlignment.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40, top: 20),
      child: Column(
        children: [
          Text(
            'Designed & Built with Flutter',
            textAlign: TextAlign.center,
            style: AppTheme.mono(size: 12.5, color: AppColors.textMuted),
          ),
          const SizedBox(height: 8),
          Text(
            '© ${DateTime.now().year} ${PortfolioData.name}',
            style: AppTheme.mono(size: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
