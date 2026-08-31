import 'package:flutter/widgets.dart';

enum ScreenSize { mobile, tablet, desktop }

abstract final class Breakpoints {
  static const tablet = 800.0;
  static const desktop = 1200.0;
  static const maxContentWidth = 1120.0;
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  ScreenSize get screenSize {
    final width = screenWidth;
    if (width < Breakpoints.tablet) return ScreenSize.mobile;
    if (width < Breakpoints.desktop) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  bool get isMobile => screenSize == ScreenSize.mobile;
  bool get isTablet => screenSize == ScreenSize.tablet;
  bool get isDesktop => screenSize == ScreenSize.desktop;

  /// Picks a value based on the current breakpoint, falling back to the
  /// next-smallest provided value.
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    return switch (screenSize) {
      ScreenSize.mobile => mobile,
      ScreenSize.tablet => tablet ?? mobile,
      ScreenSize.desktop => desktop ?? tablet ?? mobile,
    };
  }

  double get horizontalPadding => responsive(mobile: 24, tablet: 48, desktop: 80);

  double get sectionSpacing => responsive(mobile: 80, tablet: 110, desktop: 140);
}
