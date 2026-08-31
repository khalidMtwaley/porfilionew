import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:porfilionew/data/portfolio_data.dart';
import 'package:porfilionew/main.dart';
import 'package:porfilionew/widgets/fade_in_on_scroll.dart';

/// Opacity actually applied to the subtree containing [finder].
double opacityOf(WidgetTester tester, Finder finder) {
  final opacity = tester.widgetList<AnimatedOpacity>(
    find.ancestor(of: finder, matching: find.byType(AnimatedOpacity)),
  );
  expect(opacity, isNotEmpty, reason: 'no AnimatedOpacity above target');
  // Innermost wrapper wins; all must be visible for the content to show.
  return opacity.map((o) => o.opacity).reduce((a, b) => a < b ? a : b);
}

Future<void> pumpSite(WidgetTester tester, {Size size = const Size(1440, 900)}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const PortfolioApp());
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
}

void main() {
  testWidgets('content below the fold reveals after scrolling to it',
      (tester) async {
    await pumpSite(tester);

    // The contact heading starts far below the fold and hidden.
    final contactHeading = find.text('Get In Touch').last;
    expect(opacityOf(tester, contactHeading), 0.0,
        reason: 'should start hidden');

    // Scroll the page all the way down, as a user would.
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -12000),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(opacityOf(tester, contactHeading), 1.0,
        reason: 'should be visible after scrolling into view');
  });

  testWidgets('every section is visible once scrolled through', (tester) async {
    await pumpSite(tester);

    // Walk down the page in viewport-sized steps.
    for (var i = 0; i < 20; i++) {
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -700),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
    }

    // Nothing left hidden anywhere in the tree.
    final stillHidden = tester
        .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
        .where((o) => o.opacity == 0.0)
        .length;
    expect(stillHidden, 0, reason: '$stillHidden reveals never fired');
  });

  testWidgets('nav jump link reveals the section it lands on', (tester) async {
    await pumpSite(tester);

    await tester.tap(find.text('Projects').first);
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    final firstProject = find.text(PortfolioData.projects.first.name);
    expect(firstProject, findsWidgets);
    expect(opacityOf(tester, firstProject.first), 1.0,
        reason: 'jumped-to section must not stay invisible');
  });

  testWidgets('reveals still fire without a ScrollRevealScope ancestor',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FadeInOnScroll(child: Text('fallback content')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(opacityOf(tester, find.text('fallback content')), 1.0,
        reason: 'must not be permanently invisible without a scope');
  });
}
