import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/portfolio_data.dart';

abstract final class LinkLauncher {
  /// Schemes that must be handed to the OS/browser protocol handler rather than
  /// forced into an external browser window.
  static const _handlerSchemes = {'mailto', 'tel', 'sms'};

  static Future<bool> open(String url) async {
    final uri = Uri.parse(url);

    // `externalApplication` is right for http(s) — it opens a real browser tab
    // instead of an in-app webview. But on the web it makes mailto:/tel: fail
    // outright, so those need the platform's default handler.
    final mode = _handlerSchemes.contains(uri.scheme)
        ? LaunchMode.platformDefault
        : LaunchMode.externalApplication;

    try {
      final launched = await launchUrl(uri, mode: mode);
      if (launched) return true;
    } catch (e) {
      debugPrint('launchUrl threw for $url: $e');
    }

    // Fall back to the default mode before giving up — some platforms reject
    // the preferred mode but accept the default.
    if (mode != LaunchMode.platformDefault) {
      try {
        return await launchUrl(uri);
      } catch (e) {
        debugPrint('fallback launch failed for $url: $e');
      }
    }

    debugPrint('Could not launch $url');
    return false;
  }

  /// Opens the CV. On the web the asset is served from the bundle, so pointing
  /// the browser at its path opens/downloads it directly.
  static Future<bool> downloadCv() async {
    if (kIsWeb) {
      return open(PortfolioData.cvAsset);
    }

    // On desktop and mobile the bundled asset has no external URL, so hand the
    // hosted copy to the OS instead of silently doing nothing.
    return open(PortfolioData.cvUrl);
  }
}
