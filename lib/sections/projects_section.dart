import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/link_launcher.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../widgets/app_buttons.dart';
import '../widgets/fade_in_on_scroll.dart';
import '../widgets/screenshot_slider.dart';
import '../widgets/section_wrapper.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key, this.sectionKey});

  final Key? sectionKey;

  @override
  Widget build(BuildContext context) {
    final projects = PortfolioData.projects;
    final columns = context.responsive(mobile: 1, tablet: 2, desktop: 3);
    const spacing = 24.0;

    return SectionWrapper(
      sectionKey: sectionKey,
      number: '04.',
      title: 'Things I\'ve Built',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: FadeInOnScroll(
              child: Text(
                '${projects.length} shipped apps across video calling, delivery, '
                'healthcare, e-commerce and transport.',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (var i = 0; i < projects.length; i++)
                    SizedBox(
                      width: cardWidth,
                      child: FadeInOnScroll(
                        delay: Duration(milliseconds: 70 * (i % columns)),
                        child: _ProjectCard(project: projects[i]),
                      ),
                    ),
                ],
              );
            },
          ),
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
    // Placeholder links would send visitors to a store's home page rather than
    // the app, so they are hidden until real URLs are filled in.
    final links = project.links.where((l) => !l.isPlaceholder).toList();

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
              if (project.isFreelance)
                Text(
                  'freelance',
                  style: AppTheme.mono(size: 11, color: AppColors.textMuted),
                ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            project.name,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
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
          if (project.screenshots.isNotEmpty) ...[
            const SizedBox(height: 22),
            ScreenshotSlider(
              images: project.screenshots,
              projectName: project.name,
            ),
          ],
          const SizedBox(height: 22),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in project.tags) TagChip(tag, subtle: true),
            ],
          ),
          if (links.isNotEmpty) ...[
            const SizedBox(height: 24),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final link in links) StoreButton(link: link),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Labelled store button — the store name is spelled out so visitors know
/// exactly where the link goes before clicking.
class StoreButton extends StatefulWidget {
  const StoreButton({super.key, required this.link});

  final StoreLink link;

  @override
  State<StoreButton> createState() => _StoreButtonState();
}

class _StoreButtonState extends State<StoreButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final icon = switch (widget.link.kind) {
      StoreKind.googlePlay => Icons.shop_rounded,
      StoreKind.appStore => Icons.apple_rounded,
    };

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => LinkLauncher.open(widget.link.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.14)
                : AppColors.accent.withValues(alpha: 0.04),
            border: Border.all(
              color: _hovered
                  ? AppColors.accent
                  : AppColors.accent.withValues(alpha: 0.35),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.accent),
              const SizedBox(width: 8),
              Text(
                widget.link.label,
                style: AppTheme.mono(
                  size: 12.5,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
