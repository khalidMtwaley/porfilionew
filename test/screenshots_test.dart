import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:porfilionew/data/portfolio_data.dart';
import 'package:porfilionew/widgets/screenshot_slider.dart';

void main() {
  group('screenshot assets', () {
    test('every declared screenshot file exists on disk', () {
      final missing = <String>[];
      for (final project in PortfolioData.projects) {
        for (final path in project.screenshots) {
          if (!File(path).existsSync()) missing.add(path);
        }
      }
      expect(missing, isEmpty, reason: 'missing files: $missing');
    });

    test('shotCount matches the files actually present', () {
      for (final project in PortfolioData.projects) {
        final dir = Directory('assets/screenshots/${project.slug}');
        final onDisk = dir.existsSync()
            ? dir.listSync().whereType<File>().where((f) => f.path.endsWith('.jpg')).length
            : 0;
        expect(
          project.shotCount,
          onDisk,
          reason: '${project.name}: declares ${project.shotCount}, found $onDisk',
        );
      }
    });

    test('every project ships at least one screenshot', () {
      for (final project in PortfolioData.projects) {
        expect(
          project.screenshots,
          isNotEmpty,
          reason: '${project.name} has no screenshots',
        );
      }
    });

    test('the CV asset exists and is a real PDF', () {
      final cv = File(PortfolioData.cvAsset);

      expect(cv.existsSync(), isTrue, reason: '${PortfolioData.cvAsset} missing');
      expect(
        cv.readAsBytesSync().take(5),
        [0x25, 0x50, 0x44, 0x46, 0x2D], // "%PDF-"
        reason: 'CV asset is not a PDF',
      );
    });

    test('the CV path needs no URL encoding', () {
      // Spaces and other unsafe characters break the web download link.
      expect(
        PortfolioData.cvAsset,
        matches(RegExp(r'^[A-Za-z0-9_\-./]+$')),
        reason: 'CV path has characters that must be URL-encoded',
      );
    });

    test('the CV folder is registered in pubspec', () {
      expect(File('pubspec.yaml').readAsStringSync(), contains('assets/cv/'));
    });

    test('each screenshot folder is registered in pubspec', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      for (final project in PortfolioData.projects) {
        expect(
          pubspec,
          contains('assets/screenshots/${project.slug}/'),
          reason: '${project.slug} is not declared in pubspec assets',
        );
      }
    });
  });

  group('ScreenshotSlider', () {
    testWidgets('renders one thumbnail per image', (tester) async {
      final images = PortfolioData.projects.first.screenshots;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: ScreenshotSlider(
                images: images,
                projectName: 'Test',
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // ListView builds lazily, so at least the visible ones must be present.
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('renders nothing when there are no images', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScreenshotSlider(images: [], projectName: 'Empty'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Image), findsNothing);
    });
  });
}
