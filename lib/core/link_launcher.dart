import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/portfolio_data.dart';

abstract final class LinkLauncher {
  /// Schemes the OS hands to another app (mail client, dialer, SMS) rather than
  /// rendering as a page.
  static const handlerSchemes = {'mailto', 'tel', 'sms'};

  /// Window target used for handler schemes on the web.
  ///
  /// `url_launcher_web` calls `window.open(url, target)` and only defaults the
  /// target to `_top` for these schemes on Safari — everywhere else it passes
  /// an empty target, which opens a fresh tab. That tab hands the URL to the
  /// mail app and then just sits there blank. Navigating the current window
  /// instead lets the browser invoke the handler with no stray tab.
  ///
  /// Note that the web implementation ignores [LaunchMode] entirely
  /// (`supportsMode` only accepts `platformDefault`), so `webOnlyWindowName` is
  /// the only lever available there.
  static const _sameWindow = '_self';

  /// How a given URL should be launched.
  ///
  /// Pure and parameterised on [onWeb] so both platform branches are testable
  /// from the VM, where `kIsWeb` is always false.
  @visibleForTesting
  static ({LaunchMode mode, String? windowName}) planFor(
    Uri uri, {
    required bool onWeb,
  }) {
    final isHandlerScheme = handlerSchemes.contains(uri.scheme);

    // On web, keep handler schemes in the current window to avoid the blank
    // tab. Everywhere else, hand http(s) to a real browser rather than an
    // in-app webview; handler schemes go to the OS via the default mode.
    return (
      mode: (!onWeb && !isHandlerScheme)
          ? LaunchMode.externalApplication
          : LaunchMode.platformDefault,
      windowName: (onWeb && isHandlerScheme) ? _sameWindow : null,
    );
  }

  static Future<bool> open(String url) async {
    final uri = Uri.parse(url);
    final plan = planFor(uri, onWeb: kIsWeb);
    final mode = plan.mode;
    final windowName = plan.windowName;

    try {
      if (await launchUrl(uri, mode: mode, webOnlyWindowName: windowName)) {
        return true;
      }
    } catch (e) {
      debugPrint('launchUrl failed for $url: $e');
    }

    // Retry with the plugin defaults before giving up; some platforms reject a
    // specific mode but accept the default.
    if (mode != LaunchMode.platformDefault || windowName != null) {
      try {
        return await launchUrl(uri);
      } catch (e) {
        debugPrint('fallback launch failed for $url: $e');
      }
    }

    debugPrint('Could not launch $url');
    return false;
  }

  /// Opens the CV. On the web the asset ships in the bundle, so pointing the
  /// browser at its path opens it directly.
  static Future<bool> downloadCv() async {
    if (kIsWeb) {
      return open(PortfolioData.cvAsset);
    }

    // Elsewhere the bundled asset has no URL the OS can open, so use the
    // hosted copy.
    return open(PortfolioData.cvUrl);
  }
}
