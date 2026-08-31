import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/link_launcher.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import 'app_buttons.dart';

class NavItem {
  const NavItem({required this.number, required this.label, required this.onTap});

  final String number;
  final String label;
  final VoidCallback onTap;
}

/// Top navigation. Condenses (background + shadow) once the page is scrolled.
class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.items,
    required this.scrolled,
    required this.onMenuPressed,
  });

  final List<NavItem> items;
  final bool scrolled;
  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: scrolled ? 68 : 82,
      padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
      decoration: BoxDecoration(
        color: scrolled
            ? AppColors.background.withValues(alpha: 0.92)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: scrolled ? AppColors.border : Colors.transparent,
          ),
        ),
        boxShadow: scrolled
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          const _Logo(),
          const Spacer(),
          if (context.isMobile)
            IconButton(
              onPressed: onMenuPressed,
              icon: const Icon(Icons.menu_rounded),
              color: AppColors.accent,
            )
          else ...[
            for (final item in items) _NavLink(item: item),
            const SizedBox(width: 18),
            _ResumeButton(),
          ],
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accent, width: 1.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'K',
        style: AppTheme.mono(size: 18, weight: FontWeight.w700),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.item});

  final NavItem item;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.item.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.item.number, style: AppTheme.mono(size: 12)),
              const SizedBox(width: 6),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  fontSize: 14,
                  color: _hovered ? AppColors.accent : AppColors.textPrimary,
                ),
                child: Text(widget.item.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResumeButton extends StatefulWidget {
  @override
  State<_ResumeButton> createState() => _ResumeButtonState();
}

class _ResumeButtonState extends State<_ResumeButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: LinkLauncher.downloadCv,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.12)
                : Colors.transparent,
            border: Border.all(color: AppColors.accent),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text('Resume', style: AppTheme.mono(size: 13)),
        ),
      ),
    );
  }
}

/// Slide-out drawer contents for mobile navigation.
class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key, required this.items});

  final List<NavItem> items;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 20),
              for (final item in items)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.of(context).pop();
                    item.onTap();
                  },
                  title: Row(
                    children: [
                      Text(item.number, style: AppTheme.mono(size: 13)),
                      const SizedBox(width: 10),
                      Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 17,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),
              AccentButton(
                label: 'Download CV',
                icon: Icons.download_rounded,
                onPressed: () {
                  Navigator.of(context).pop();
                  LinkLauncher.downloadCv();
                },
              ),
              const Spacer(),
              Text(
                PortfolioData.email,
                style: AppTheme.mono(size: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
