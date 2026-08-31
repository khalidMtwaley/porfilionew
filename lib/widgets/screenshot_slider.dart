import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_theme.dart';

/// Horizontal strip of store screenshots with arrows, page dots, and a
/// full-screen viewer on tap.
///
/// The strip scrolls one "page" per arrow press, where a page is however many
/// thumbnails currently fit — so the control behaves the same on a narrow
/// mobile card and a wide desktop one.
class ScreenshotSlider extends StatefulWidget {
  const ScreenshotSlider({
    super.key,
    required this.images,
    required this.projectName,
    this.height = 210,
  });

  final List<String> images;
  final String projectName;
  final double height;

  @override
  State<ScreenshotSlider> createState() => _ScreenshotSliderState();
}

class _ScreenshotSliderState extends State<ScreenshotSlider> {
  final _controller = ScrollController();

  double _page = 0;
  double _maxPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final viewport = _controller.position.viewportDimension;
    if (viewport <= 0) return;

    final max = _controller.position.maxScrollExtent;
    setState(() {
      _page = _controller.offset / viewport;
      _maxPage = max / viewport;
    });
  }

  void _step(int direction) {
    if (!_controller.hasClients) return;
    final viewport = _controller.position.viewportDimension;
    final target = (_controller.offset + viewport * direction).clamp(
      0.0,
      _controller.position.maxScrollExtent,
    );
    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _openViewer(int index) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.92),
        pageBuilder: (_, _, _) => _FullScreenViewer(
          images: widget.images,
          initialIndex: index,
          projectName: widget.projectName,
        ),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    // Only show controls when there is actually somewhere to scroll.
    final scrollable = _maxPage > 0.01;
    final canGoBack = _page > 0.01;
    final canGoForward = _page < _maxPage - 0.01;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: widget.height,
          child: Stack(
            children: [
              ScrollConfiguration(
                // Let the strip be dragged with a mouse, not just a trackpad.
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.trackpad,
                    PointerDeviceKind.stylus,
                  },
                  scrollbars: false,
                ),
                child: ListView.separated(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: widget.images.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, i) => _Thumbnail(
                    path: widget.images[i],
                    height: widget.height,
                    onTap: () => _openViewer(i),
                  ),
                ),
              ),
              if (scrollable && canGoBack)
                _ArrowButton(
                  alignment: Alignment.centerLeft,
                  icon: Icons.chevron_left_rounded,
                  onTap: () => _step(-1),
                ),
              if (scrollable && canGoForward)
                _ArrowButton(
                  alignment: Alignment.centerRight,
                  icon: Icons.chevron_right_rounded,
                  onTap: () => _step(1),
                ),
            ],
          ),
        ),
        if (scrollable) ...[
          const SizedBox(height: 12),
          _PageDots(page: _page, maxPage: _maxPage),
        ],
      ],
    );
  }
}

class _Thumbnail extends StatefulWidget {
  const _Thumbnail({
    required this.path,
    required this.height,
    required this.onTap,
  });

  final String path;
  final double height;
  final VoidCallback onTap;

  @override
  State<_Thumbnail> createState() => _ThumbnailState();
}

class _ThumbnailState extends State<_Thumbnail> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered
                  ? AppColors.accent.withValues(alpha: 0.6)
                  : AppColors.border,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Image.asset(
                widget.path,
                height: widget.height,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
                errorBuilder: (_, _, _) => _ThumbnailFallback(
                  height: widget.height,
                ),
              ),
              // Slight dim lifts on hover, hinting the image is clickable.
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                color: Colors.black.withValues(alpha: _hovered ? 0.0 : 0.18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThumbnailFallback extends StatelessWidget {
  const _ThumbnailFallback({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: height * 0.48,
      color: AppColors.surfaceElevated,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.textMuted,
          size: 22,
        ),
      ),
    );
  }
}

class _ArrowButton extends StatefulWidget {
  const _ArrowButton({
    required this.alignment,
    required this.icon,
    required this.onTap,
  });

  final Alignment alignment;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<_ArrowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hovered
                    ? AppColors.accent
                    : AppColors.background.withValues(alpha: 0.85),
                border: Border.all(
                  color: _hovered ? AppColors.accent : AppColors.border,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                size: 20,
                color: _hovered ? AppColors.background : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.page, required this.maxPage});

  final double page;
  final double maxPage;

  @override
  Widget build(BuildContext context) {
    final count = maxPage.ceil() + 1;
    final active = page.round().clamp(0, count - 1);

    return Row(
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.only(right: 6),
            width: i == active ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == active
                  ? AppColors.accent
                  : AppColors.border,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}

/// Full-screen gallery opened by tapping a thumbnail.
class _FullScreenViewer extends StatefulWidget {
  const _FullScreenViewer({
    required this.images,
    required this.initialIndex,
    required this.projectName,
  });

  final List<String> images;
  final int initialIndex;
  final String projectName;

  @override
  State<_FullScreenViewer> createState() => _FullScreenViewerState();
}

class _FullScreenViewerState extends State<_FullScreenViewer> {
  late final PageController _pageController =
      PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _go(int delta) {
    final next = (_index + delta).clamp(0, widget.images.length - 1);
    if (next == _index) return;
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  KeyEventResult _onKey(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowRight:
        _go(1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowLeft:
        _go(-1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.escape:
        Navigator.of(context).pop();
        return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Tapping the backdrop closes the viewer.
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text(
                        widget.projectName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        '${_index + 1} / ${widget.images.length}',
                        style: AppTheme.mono(size: 13),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                        color: AppColors.textPrimary,
                        tooltip: 'Close',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: widget.images.length,
                        onPageChanged: (i) => setState(() => _index = i),
                        itemBuilder: (context, i) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 20,
                          ),
                          child: InteractiveViewer(
                            maxScale: 4,
                            child: Image.asset(
                              widget.images[i],
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              errorBuilder: (_, _, _) => const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: AppColors.textMuted,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_index > 0)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _ViewerArrow(
                            icon: Icons.chevron_left_rounded,
                            onTap: () => _go(-1),
                          ),
                        ),
                      if (_index < widget.images.length - 1)
                        Align(
                          alignment: Alignment.centerRight,
                          child: _ViewerArrow(
                            icon: Icons.chevron_right_rounded,
                            onTap: () => _go(1),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewerArrow extends StatelessWidget {
  const _ViewerArrow({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: AppColors.surface.withValues(alpha: 0.9),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, size: 28, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
