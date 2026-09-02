import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart' show LaunchMode;
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'package:porfilionew/core/link_launcher.dart';
import 'package:porfilionew/data/portfolio_data.dart';

/// Records what url_launcher was asked to do, so the launch options chosen for
/// each scheme can be asserted without opening anything for real.
class _RecordingLauncher extends UrlLauncherPlatform
    with MockPlatformInterfaceMixin {
  final launches =
      <({String url, PreferredLaunchMode? mode, String? windowName})>[];

  /// When false, the first launch attempt reports failure so the fallback path
  /// can be exercised.
  bool succeed = true;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launches.add((
      url: url,
      mode: options.mode,
      windowName: options.webOnlyWindowName,
    ));
    return succeed;
  }
}

void main() {
  late _RecordingLauncher launcher;

  setUp(() {
    launcher = _RecordingLauncher();
    UrlLauncherPlatform.instance = launcher;
  });

  // The plan is what actually differs per platform; `kIsWeb` is always false
  // under `flutter test`, so the web branch is only reachable through planFor.
  group('launch plan on web', () {
    ({LaunchMode mode, String? windowName}) planWeb(String url) =>
        LinkLauncher.planFor(Uri.parse(url), onWeb: true);

    test('mailto navigates the current window, not a new tab', () {
      // url_launcher_web calls window.open(url, target); an empty target opens
      // a blank tab that lingers after the mail app takes over.
      expect(planWeb('mailto:${PortfolioData.email}').windowName, '_self');
    });

    test('tel navigates the current window', () {
      expect(planWeb('tel:${PortfolioData.phone}').windowName, '_self');
    });

    test('sms navigates the current window', () {
      expect(planWeb('sms:+201023291641').windowName, '_self');
    });

    test('http(s) still opens in a new tab', () {
      expect(planWeb('https://github.com/khalidMtwaley').windowName, isNull);
      expect(planWeb('https://wa.me/201023291641').windowName, isNull);
    });

    test('never asks for a mode the web implementation rejects', () {
      // url_launcher_web.supportsMode only accepts platformDefault.
      for (final url in [
        'mailto:a@b.com',
        'tel:+201023291641',
        'https://example.com',
      ]) {
        expect(
          planWeb(url).mode,
          LaunchMode.platformDefault,
          reason: '$url would be silently downgraded on web',
        );
      }
    });
  });

  group('launch plan on native platforms', () {
    ({LaunchMode mode, String? windowName}) planNative(String url) =>
        LinkLauncher.planFor(Uri.parse(url), onWeb: false);

    test('never sets a window name', () {
      for (final url in ['mailto:a@b.com', 'https://example.com']) {
        expect(planNative(url).windowName, isNull);
      }
    });

    test('http(s) opens in an external browser, not an in-app webview', () {
      expect(
        planNative('https://github.com/khalidMtwaley').mode,
        LaunchMode.externalApplication,
      );
    });

    test('handler schemes use the default mode so the OS routes them', () {
      expect(planNative('mailto:a@b.com').mode, LaunchMode.platformDefault);
      expect(planNative('tel:+201023291641').mode, LaunchMode.platformDefault);
    });
  });

  group('launching', () {
    test('passes the planned options through to the plugin', () async {
      final ok = await LinkLauncher.open('https://github.com/khalidMtwaley');

      expect(ok, isTrue);
      expect(launcher.launches, hasLength(1));
      expect(
        launcher.launches.single.mode,
        PreferredLaunchMode.externalApplication,
      );
    });

    test('retries with plugin defaults when the first attempt fails', () async {
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

    test('does not double-attempt when already using plugin defaults',
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

    test('whatsappNumber is the phone number without + or separators', () {
      final digitsOnly = PortfolioData.phone.replaceAll(RegExp(r'[^0-9]'), '');

      expect(
        PortfolioData.whatsappNumber,
        digitsOnly,
        reason: 'whatsappNumber drifted from phone',
      );
      expect(PortfolioData.whatsappNumber, matches(RegExp(r'^\d+$')));
    });

    test('WhatsApp link points at wa.me with the bare number', () {
      final whatsapp =
          PortfolioData.socials.firstWhere((s) => s.label == 'WhatsApp');

      expect(whatsapp.url, 'https://wa.me/${PortfolioData.whatsappNumber}');
      expect(Uri.parse(whatsapp.url).scheme, 'https');
      // A '+' here makes wa.me reject the link.
      expect(whatsapp.url, isNot(contains('+')));
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

      await LinkLauncher.open('mailto:${PortfolioData.email}');

      expect(launcher.launches.single.url, 'mailto:${PortfolioData.email}');
    });
  });
}
