import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/responsive.dart';
import 'fade_in_on_scroll.dart';

/// Standard padded section with a numbered heading, used by every content
/// section so spacing and typography stay consistent down the page.
class SectionWrapper extends StatelessWidget {
  const SectionWrapper({
    super.key,
    required this.number,
    required this.title,
    required this.child,
    this.sectionKey,
  });

  final String number;
  final String title;
  final Widget child;
  final Key? sectionKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalPadding,
        vertical: context.sectionSpacing / 2,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.maxContentWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInOnScroll(child: _Heading(number: number, title: title)),
              SizedBox(height: context.responsive(mobile: 36, desktop: 52)),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.number, required this.title});

  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    final titleSize = context.responsive<double>(
      mobile: 28,
      tablet: 34,
      desktop: 38,
    );

    return Row(
      children: [
        Text(number, style: AppTheme.mono(size: titleSize * 0.55)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(width: 20),
        const Expanded(
          child: Divider(color: AppColors.border, thickness: 1),
        ),
      ],
    );
  }
}
