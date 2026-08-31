import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/link_launcher.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../widgets/app_buttons.dart';
import '../widgets/fade_in_on_scroll.dart';
import '../widgets/section_wrapper.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key, this.sectionKey});

  final Key? sectionKey;

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  static const _collapsedCount = 6;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final all = PortfolioData.projects;
    final visible = _expanded ? all : all.take(_collapsedCount).toList();
    final columns = context.responsive(mobile: 1, tablet: 2, desktop: 3);
    const spacing = 24.0;

    return SectionWrapper(
      sectionKey: widget.sectionKey,
      number: '04.',
      title: 'Things I\'ve Built',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (var i = 0; i < visible.length; i++)
                    SizedBox(
                      width: cardWidth,
                      child: FadeInOnScroll(
                        delay: Duration(milliseconds: 70 * (i % columns)),
                        child: _ProjectCard(project: visible[i]),
                      ),
                    ),
                ],
              );
            },
          ),
          if (all.length > _collapsedCount) ...[
            const SizedBox(height: 48),
            Center(
              child: AccentButton(
                label: _expanded
                    ? 'Show Less'
                    : 'Show More (${all.length - _collapsedCount})',
                icon: _expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                onPressed: () => setState(() => _expanded = !_expanded),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.folder_outlined,
                size: 30,
                color: AppColors.accent.withValues(alpha: 0.85),
              ),
              const Spacer(),
              for (final link in project.links)
                _StoreIconButton(link: link),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Flexible(
                child: Text(
                  project.name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (project.isFreelance) ...[
                const SizedBox(width: 10),
                Text(
                  'freelance',
                  style: AppTheme.mono(size: 11, color: AppColors.textMuted),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Text(
            project.description,
            style: const TextStyle(
              fontSize: 14.5,
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in project.tags) TagChip(tag, subtle: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoreIconButton extends StatelessWidget {
  const _StoreIconButton({required this.link});

  final StoreLink link;

  @override
  Widget build(BuildContext context) {
    final isAppStore = link.label.toLowerCase().contains('app store');

    return Tooltip(
      message: link.label,
      child: IconButton(
        onPressed: () => LinkLauncher.open(link.url),
        icon: Icon(
          isAppStore ? Icons.apple_rounded : Icons.shop_rounded,
          size: 20,
        ),
        color: AppColors.textMuted,
        hoverColor: AppColors.accent.withValues(alpha: 0.1),
        splashRadius: 20,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
