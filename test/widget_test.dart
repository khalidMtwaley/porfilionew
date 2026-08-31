import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:porfilionew/data/portfolio_data.dart';
import 'package:porfilionew/main.dart';

/// Renders the site at a desktop size and lets the staggered reveal timers and
/// their animations finish, so no timers are left pending at teardown.
Future<void> pumpPortfolio(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1440, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const PortfolioApp());
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
}

void main() {
  testWidgets('renders the hero with name and CTAs', (tester) async {
    await pumpPortfolio(tester);

    expect(find.text('${PortfolioData.name}.'), findsOneWidget);
    expect(find.text('Download CV'), findsOneWidget);
    // Also the Contact section heading, hence findsWidgets.
    expect(find.text('Get In Touch'), findsWidgets);
  });

  testWidgets('shows the desktop navigation links', (tester) async {
    await pumpPortfolio(tester);

    for (final label in ['About', 'Skills', 'Experience', 'Projects', 'Contact']) {
      expect(find.text(label), findsWidgets, reason: 'missing nav link $label');
    }
  });

  testWidgets('lists every company and every project', (tester) async {
    await pumpPortfolio(tester);

    for (final experience in PortfolioData.experiences) {
      expect(
        find.text(experience.company),
        findsWidgets,
        reason: 'missing company ${experience.company}',
      );
    }

    // All projects render at once — no expand/collapse gate.
    for (final project in PortfolioData.projects) {
      expect(
        find.text(project.name),
        findsWidgets,
        reason: 'missing project ${project.name}',
      );
    }
  });

  testWidgets('has no show-more gate hiding projects', (tester) async {
    await pumpPortfolio(tester);

    expect(find.textContaining('Show More'), findsNothing);
    expect(find.textContaining('Show Less'), findsNothing);
  });
}
