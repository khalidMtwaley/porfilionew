import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/link_launcher.dart';
import '../data/portfolio_data.dart';

/// Rounded contact chip — icon plus handle — used in both the hero contact bar
/// and the closing contact section.
class SocialPill extends StatefulWidget {
  const SocialPill({super.key, required this.social, this.compact = false});

  final SocialLink social;

  /// Tighter padding and type, for the dense bar at the top of the page.
  final bool compact;

  @override
  State<SocialPill> createState() => _SocialPillState();
}

class _SocialPillState extends State<SocialPill> {
  bool _hovered = false;

  IconData get _icon => switch (widget.social.label) {
        'GitHub' => Icons.code_rounded,
        'LinkedIn' => Icons.business_center_outlined,
        'Email' => Icons.alternate_email_rounded,
        'WhatsApp' => Icons.chat_bubble_outline_rounded,
        _ => Icons.phone_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final compact = widget.compact;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => LinkLauncher.open(widget.social.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 14 : 18,
            vertical: compact ? 9 : 12,
          ),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surfaceElevated : AppColors.surface,
            border: Border.all(
              color: _hovered ? AppColors.accent : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _icon,
                size: compact ? 15 : 17,
                color: _hovered ? AppColors.accent : AppColors.textMuted,
              ),
              SizedBox(width: compact ? 8 : 10),
              Text(
                widget.social.handle,
                style: TextStyle(
                  fontSize: compact ? 12.5 : 13.5,
                  color: _hovered
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The full set of contact links laid out in one wrapping row.
class ContactBar extends StatelessWidget {
  const ContactBar({
    super.key,
    this.compact = false,
    this.alignment = WrapAlignment.start,
  });

  final bool compact;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: compact ? 10 : 14,
      runSpacing: compact ? 10 : 14,
      alignment: alignment,
      children: [
        for (final social in PortfolioData.socials)
          SocialPill(social: social, compact: compact),
      ],
    );
  }
}
