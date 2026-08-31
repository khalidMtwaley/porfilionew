import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../widgets/app_buttons.dart';
import '../widgets/fade_in_on_scroll.dart';
import '../widgets/section_wrapper.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key, this.sectionKey});

  final Key? sectionKey;

  @override
  Widget build(BuildContext context) {
    final columns = context.responsive(mobile: 1, tablet: 2, desktop: 3);
    const spacing = 24.0;

    return SectionWrapper(
      sectionKey: sectionKey,
      number: '02.',
      title: 'Skills & Tools',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (var i = 0; i < PortfolioData.skillGroups.length; i++)
                SizedBox(
                  width: cardWidth,
                  child: FadeInOnScroll(
                    delay: Duration(milliseconds: 70 * (i % columns)),
                    child: _SkillGroupCard(
                      group: PortfolioData.skillGroups[i],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SkillGroupCard extends StatelessWidget {
  const _SkillGroupCard({required this.group});

  final SkillGroup group;

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            group.title,
            style: AppTheme.mono(size: 13, weight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final skill in group.skills) TagChip(skill, subtle: true),
            ],
          ),
        ],
      ),
    );
  }
}
