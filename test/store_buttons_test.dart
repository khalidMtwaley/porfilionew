import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:porfilionew/data/portfolio_data.dart';
import 'package:porfilionew/sections/projects_section.dart';

void main() {
  group('StoreLink', () {
    test('labels each store by kind', () {
      const play = StoreLink(
        kind: StoreKind.googlePlay,
        url: 'https://play.google.com/store/apps/details?id=com.example',
      );
      const app = StoreLink(
        kind: StoreKind.appStore,
        url: 'https://apps.apple.com/app/id123456',
      );

      expect(play.label, 'Google Play');
      expect(app.label, 'App Store');
    });

    test('flags store home pages as placeholders', () {
      const play = StoreLink(
        kind: StoreKind.googlePlay,
        url: 'https://play.google.com/store',
      );
      const app = StoreLink(
        kind: StoreKind.appStore,
        url: 'https://apps.apple.com',
      );

      expect(play.isPlaceholder, isTrue);
      expect(app.isPlaceholder, isTrue);
    });

    test('treats a real app URL as usable', () {
      const real = StoreLink(
        kind: StoreKind.googlePlay,
        url: 'https://play.google.com/store/apps/details?id=com.keme.meet',
      );

      expect(real.isPlaceholder, isFalse);
    });
  });

  test('every project ships at least one real store link', () {
    for (final project in PortfolioData.projects) {
      expect(
        project.links,
        isNotEmpty,
        reason: '${project.name} has no store links',
      );
      expect(
        project.links.where((l) => !l.isPlaceholder),
        isNotEmpty,
        reason: '${project.name} still has only placeholder links',
      );
    }
  });

  test('store links point at a specific app, not a store home page', () {
    for (final project in PortfolioData.projects) {
      for (final link in project.links) {
        switch (link.kind) {
          case StoreKind.googlePlay:
            expect(
              link.url,
              contains('/store/apps/details?id='),
              reason: '${project.name}: Play link is not an app URL',
            );
          case StoreKind.appStore:
            expect(
              link.url,
              matches(RegExp(r'/id\d+$')),
              reason: '${project.name}: App Store link is not an app URL',
            );
        }
      }
    }
  });

  testWidgets('renders a labelled button for a real store link',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StoreButton(
            link: StoreLink(
              kind: StoreKind.googlePlay,
              url: 'https://play.google.com/store/apps/details?id=com.example',
            ),
          ),
        ),
      ),
    );

    // The store name is spelled out, not just an icon.
    expect(find.text('Google Play'), findsOneWidget);
  });
}
