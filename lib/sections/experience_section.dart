import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../widgets/fade_in_on_scroll.dart';
import '../widgets/section_wrapper.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key, this.sectionKey});

  final Key? sectionKey;

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: widget.sectionKey,
      number: '03.',
      title: 'Where I\'ve Worked',
      child: FadeInOnScroll(
        child: context.isMobile ? _buildStacked() : _buildTabbed(),
      ),
    );
  }

  /// Desktop/tablet: a vertical company rail beside the selected role's detail.
  Widget _buildTabbed() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < PortfolioData.experiences.length; i++)
                  _CompanyTab(
                    label: PortfolioData.experiences[i].company,
                    selected: _selected == i,
                    onTap: () => setState(() => _selected = i),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _ExperienceDetail(
                key: ValueKey(_selected),
                experience: PortfolioData.experiences[_selected],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Mobile: every role stacked, each with a left accent rail.
  Widget _buildStacked() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < PortfolioData.experiences.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == PortfolioData.experiences.length - 1 ? 0 : 40,
            ),
            child: Container(
              padding: const EdgeInsets.only(left: 20),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppColors.accent, width: 2),
                ),
              ),
              child: _ExperienceDetail(
                experience: PortfolioData.experiences[i],
              ),
            ),
          ),
      ],
    );
  }
}

class _CompanyTab extends StatefulWidget {
  const _CompanyTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_CompanyTab> createState() => _CompanyTabState();
}

class _CompanyTabState extends State<_CompanyTab> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: active
                ? AppColors.accent.withValues(alpha: 0.08)
                : (_hovered ? AppColors.surface : Colors.transparent),
            border: Border(
              left: BorderSide(
                color: active ? AppColors.accent : AppColors.border,
                width: active ? 2.5 : 1.5,
              ),
            ),
          ),
          child: Text(
            widget.label,
            style: AppTheme.mono(
              size: 13.5,
              color: active ? AppColors.accent : AppColors.textSecondary,
              weight: active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _ExperienceDetail extends StatelessWidget {
  const _ExperienceDetail({super.key, required this.experience});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: experience.role,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              TextSpan(
                text: ' @ ${experience.company}',
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 16,
          children: [
            Text(experience.period,
                style: AppTheme.mono(size: 13, color: AppColors.textMuted)),
            Text('·', style: AppTheme.mono(size: 13, color: AppColors.textMuted)),
            Text(experience.location,
                style: AppTheme.mono(size: 13, color: AppColors.textMuted)),
          ],
        ),
        const SizedBox(height: 26),
        for (final highlight in experience.highlights)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Icon(
                    Icons.arrow_right_alt_rounded,
                    size: 16,
                    color: AppColors.accent.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    highlight,
                    style: const TextStyle(
                      fontSize: 15.5,
                      color: AppColors.textSecondary,
                      height: 1.65,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
