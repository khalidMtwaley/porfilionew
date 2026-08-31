import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:porfilionew/core/app_theme.dart';
import 'package:porfilionew/data/portfolio_data.dart';
import 'package:porfilionew/main.dart';
import 'package:porfilionew/widgets/social_pill.dart';

/// WCAG relative luminance.
double _luminance(Color c) {
  double channel(double v) =>
      v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * channel(c.r) +
      0.7152 * channel(c.g) +
      0.0722 * channel(c.b);
}

double contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final hi = math.max(la, lb);
  final lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

Future<void> pumpSite(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1440, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const PortfolioApp());
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
}

void main() {
  group('text contrast', () {
    test('secondary text meets WCAG AA on both dark surfaces', () {
      for (final bg in [AppColors.background, AppColors.surface]) {
        expect(
          contrast(AppColors.textSecondary, bg),
          greaterThanOrEqualTo(4.5),
          reason: 'textSecondary is too dim on $bg',
        );
      }
    });

    test('muted text meets WCAG AA on both dark surfaces', () {
      for (final bg in [AppColors.background, AppColors.surface]) {
        expect(
          contrast(AppColors.textMuted, bg),
          greaterThanOrEqualTo(4.5),
          reason: 'textMuted is too dim on $bg',
        );
      }
    });

    test('primary text stays the brightest of the three', () {
      expect(
        contrast(AppColors.textPrimary, AppColors.background),
        greaterThan(contrast(AppColors.textSecondary, AppColors.background)),
      );
      expect(
        contrast(AppColors.textSecondary, AppColors.background),
        greaterThan(contrast(AppColors.textMuted, AppColors.background)),
      );
    });
  });

  group('section order', () {
    testWidgets('nav lists About, Experience, Projects, Skills in order',
        (tester) async {
      await pumpSite(tester);

      const expected = ['About', 'Experience', 'Projects', 'Skills'];
      final xs = <String, double>{};
      for (final label in expected) {
        // The nav row is the topmost occurrence of each label.
        final matches = tester.widgetList<Text>(find.text(label));
        expect(matches, isNotEmpty, reason: 'nav link $label missing');
        xs[label] = tester
            .getTopLeft(find.text(label).first)
            .dx;
      }

      final sorted = [...expected]..sort((a, b) => xs[a]!.compareTo(xs[b]!));
      expect(sorted, expected, reason: 'nav order is wrong: $xs');
    });

    testWidgets('sections appear down the page in the intended order',
        (tester) async {
      await pumpSite(tester);

      // Section headings carry their number, so match on those.
      const headings = {
        '01.': 'About Me',
        '02.': 'Where I\'ve Worked',
        '03.': 'Things I\'ve Built',
        '04.': 'Skills & Tools',
      };

      double? previousY;
      for (final entry in headings.entries) {
        final finder = find.text(entry.value);
        expect(finder, findsWidgets, reason: 'missing section ${entry.value}');
        final y = tester.getTopLeft(finder.first).dy;
        if (previousY != null) {
          expect(
            y,
            greaterThan(previousY),
            reason: '${entry.value} should come after the previous section',
          );
        }
        previousY = y;
      }
    });

    testWidgets('numbering runs 01 to 05 with no gaps or repeats',
        (tester) async {
      await pumpSite(tester);

      for (final n in ['01.', '02.', '03.', '04.']) {
        expect(
          find.text(n),
          findsWidgets,
          reason: 'section number $n not rendered',
        );
      }
      expect(find.text('05. What\'s Next?'), findsOneWidget);
    });
  });

  group('hero contact bar', () {
    testWidgets('shows every contact link near the top of the page',
        (tester) async {
      await pumpSite(tester);

      // A ContactBar in the hero plus one in the contact section.
      expect(find.byType(ContactBar), findsNWidgets(2));

      for (final social in PortfolioData.socials) {
        expect(
          find.text(social.handle),
          findsWidgets,
          reason: 'missing contact handle ${social.handle}',
        );
      }
    });

    testWidgets('hero contact bar sits above the About section',
        (tester) async {
      await pumpSite(tester);

      final heroBarY = tester.getTopLeft(find.byType(ContactBar).first).dy;
      final aboutY = tester.getTopLeft(find.text('About Me').first).dy;

      expect(heroBarY, lessThan(aboutY));
    });

    testWidgets('contact section is still last', (tester) async {
      await pumpSite(tester);

      final skillsY = tester.getTopLeft(find.text('Skills & Tools').first).dy;
      final contactY =
          tester.getTopLeft(find.text('05. What\'s Next?').first).dy;

      expect(contactY, greaterThan(skillsY));
    });
  });
}
