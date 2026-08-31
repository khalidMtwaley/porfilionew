import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/portfolio_data.dart';

abstract final class LinkLauncher {
  static Future<void> open(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  /// Downloads the CV. On web the asset is served directly from the bundle, so
  /// pointing the browser at its path triggers a normal file download.
  static Future<void> downloadCv() async {
    if (kIsWeb) {
      await open('${PortfolioData.cvAsset}?download=${PortfolioData.cvFileName}');
      return;
    }

    // On non-web builds, copy the asset out and hand it to the OS viewer.
    final bytes = await rootBundle.load(PortfolioData.cvAsset);
    debugPrint('CV loaded (${bytes.lengthInBytes} bytes) — open externally.');
  }
}
