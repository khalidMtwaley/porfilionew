import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../widgets/app_buttons.dart';
import '../widgets/fade_in_on_scroll.dart';
import '../widgets/section_wrapper.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key, this.sectionKey});

  final Key? sectionKey;

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: sectionKey,
      number: '01.',
      title: 'About Me',
      child: FadeInOnScroll(
        child: context.isMobile
            ? const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bio(),
                  SizedBox(height: 36),
                  _EducationCard(),
                ],
              )
            : const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _Bio()),
                  SizedBox(width: 56),
                  Expanded(flex: 2, child: _EducationCard()),
                ],
              ),
      ),
    );
  }
}

class _Bio extends StatelessWidget {
  const _Bio();

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
      fontSize: 16.5,
      color: AppColors.textSecondary,
      height: 1.85,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(PortfolioData.about, style: bodyStyle),
        const SizedBox(height: 28),
        const Text(
          'Across four companies I have shipped apps to the Play Store and '
          'App Store covering video conferencing, food delivery, healthcare, '
          'e-commerce, and transport — usually built on Clean Architecture '
          'with Cubit, and shipped through automated CI/CD pipelines.',
          style: bodyStyle,
        ),
        const SizedBox(height: 32),
        Text(
          'A few technologies I work with day to day:',
          style: AppTheme.mono(size: 13, color: AppColors.textMuted),
        ),
        const SizedBox(height: 16),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            TagChip('Flutter'),
            TagChip('Dart'),
            TagChip('Clean Architecture'),
            TagChip('Bloc / Cubit'),
            TagChip('Firebase'),
            TagChip('CI/CD'),
          ],
        ),
      ],
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard();

  @override
  Widget build(BuildContext context) {
    const education = PortfolioData.education;

    return HoverCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.school_outlined,
                size: 20,
                color: AppColors.accent,
              ),
              const SizedBox(width: 10),
              Text(
                'Education',
                style: AppTheme.mono(size: 13, weight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            education.degree,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            education.school,
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          Text(education.period, style: AppTheme.mono(size: 13)),
          const SizedBox(height: 26),
          const Divider(color: AppColors.border),
          const SizedBox(height: 20),
          const _InfoRow(
            icon: Icons.location_on_outlined,
            text: PortfolioData.location,
          ),
          const SizedBox(height: 12),
          const _InfoRow(
            icon: Icons.work_outline_rounded,
            text: 'Open to remote , onsite opportunities and freelance work',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.textMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
