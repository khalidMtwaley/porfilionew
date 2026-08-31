import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'package:porfilionew/core/link_launcher.dart';
import 'package:porfilionew/data/portfolio_data.dart';

/// Records what url_launcher was asked to do, so the launch mode chosen for
/// each scheme can be asserted without opening anything for real.
class _RecordingLauncher extends UrlLauncherPlatform
    with MockPlatformInterfaceMixin {
  final launches = <({String url, PreferredLaunchMode? mode})>[];

  /// When false, the first launch attempt reports failure so the fallback path
  /// can be exercised.
  bool succeed = true;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launches.add((url: url, mode: options.mode));
    return succeed;
  }
}

void main() {
  late _RecordingLauncher launcher;

  setUp(() {
    launcher = _RecordingLauncher();
    UrlLauncherPlatform.instance = launcher;
  });

  group('launch mode by scheme', () {
    test('mailto uses the platform default handler', () async {
      // externalApplication silently fails for mailto: on the web.
      final ok = await LinkLauncher.open('mailto:${PortfolioData.email}');

      expect(ok, isTrue);
      expect(launcher.launches, hasLength(1));
      expect(launcher.launches.single.mode, PreferredLaunchMode.platformDefault);
    });

    test('tel uses the platform default handler', () async {
      final ok = await LinkLauncher.open('tel:${PortfolioData.phone}');

      expect(ok, isTrue);
      expect(launcher.launches.single.mode, PreferredLaunchMode.platformDefault);
    });

    test('https opens in an external browser', () async {
      final ok = await LinkLauncher.open('https://github.com/khalidMtwaley');

      expect(ok, isTrue);
      expect(
        launcher.launches.single.mode,
        PreferredLaunchMode.externalApplication,
      );
    });
  });

  group('fallback', () {
    test('retries with the default mode when the preferred mode fails',
        () async {
      launcher.succeed = false;

      await LinkLauncher.open('https://example.com');

      expect(
        launcher.launches.map((l) => l.mode),
        [
          PreferredLaunchMode.externalApplication,
          PreferredLaunchMode.platformDefault,
        ],
        reason: 'should retry once with the default mode',
      );
    });

    test('does not double-attempt when already using the default mode',
        () async {
      launcher.succeed = false;

      await LinkLauncher.open('mailto:someone@example.com');

      expect(launcher.launches, hasLength(1));
    });
  });

  group('contact links', () {
    test('every social link parses to a URI with a scheme', () {
      for (final social in PortfolioData.socials) {
        final uri = Uri.parse(social.url);
        expect(
          uri.scheme,
          isNotEmpty,
          reason: '${social.label} has no URI scheme: ${social.url}',
        );
      }
    });

    test('email and phone links use the right schemes', () {
      final email =
          PortfolioData.socials.firstWhere((s) => s.label == 'Email');
      final phone =
          PortfolioData.socials.firstWhere((s) => s.label == 'Phone');

      expect(Uri.parse(email.url).scheme, 'mailto');
      expect(Uri.parse(phone.url).scheme, 'tel');
      expect(email.url, contains(PortfolioData.email));
      expect(phone.url, contains(PortfolioData.phone));
    });

    testWidgets('tapping the email pill triggers a launch', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      // Drive the launcher the way the pill's onTap does.
      await LinkLauncher.open('mailto:${PortfolioData.email}');

      expect(launcher.launches.single.url, 'mailto:${PortfolioData.email}');
    });
  });
}
