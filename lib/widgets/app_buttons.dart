import 'package:flutter/material.dart';

import '../core/app_theme.dart';

/// Outlined accent button with a subtle lift + glow on hover.
class AccentButton extends StatefulWidget {
  const AccentButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.filled = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool filled;

  @override
  State<AccentButton> createState() => _AccentButtonState();
}

class _AccentButtonState extends State<AccentButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final background = widget.filled
        ? (_hovered ? AppColors.accent : AppColors.accentSoft)
        : (_hovered ? AppColors.accent.withValues(alpha: 0.12) : Colors.transparent);
    final foreground =
        widget.filled ? AppColors.background : AppColors.accent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
          decoration: BoxDecoration(
            color: background,
            border: Border.all(color: AppColors.accent, width: 1.2),
            borderRadius: BorderRadius.circular(6),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 18, color: foreground),
                const SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: AppTheme.mono(
                  size: 14,
                  color: foreground,
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

/// Small pill used for skills and project tech tags.
class TagChip extends StatelessWidget {
  const TagChip(this.label, {super.key, this.subtle = false});

  final String label;
  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: subtle
            ? AppColors.surfaceElevated
            : AppColors.accent.withValues(alpha: 0.08),
        border: Border.all(
          color: subtle
              ? AppColors.border
              : AppColors.accent.withValues(alpha: 0.25),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTheme.mono(
          size: 12,
          color: subtle ? AppColors.textSecondary : AppColors.accent,
        ),
      ),
    );
  }
}

/// Card that raises and brightens its border on hover.
class HoverCard extends StatefulWidget {
  const HoverCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(28),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: _hovered ? AppColors.surfaceElevated : AppColors.surface,
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.4)
                : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ]
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}
