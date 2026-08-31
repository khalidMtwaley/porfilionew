import 'package:flutter/material.dart';

/// Broadcasts "the page scrolled" to every [FadeInOnScroll] below it.
///
/// A single listener at the top of the page drives all reveals. Each child
/// re-checks its own position only while it is still hidden, and unsubscribes
/// the moment it becomes visible — so a fully-revealed page does no work at all
/// during scrolling.
class ScrollRevealScope extends StatefulWidget {
  const ScrollRevealScope({super.key, required this.child});

  final Widget child;

  @override
  State<ScrollRevealScope> createState() => _ScrollRevealScopeState();

  static ScrollRevealController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ScrollRevealMarker>()
        ?.controller;
  }
}

/// The subscription hub a [ScrollRevealScope] hands down to its descendants.
class ScrollRevealController {
  final _listeners = <VoidCallback>{};

  void subscribe(VoidCallback listener) => _listeners.add(listener);

  void unsubscribe(VoidCallback listener) => _listeners.remove(listener);

  void notify() {
    // Copy first: listeners unsubscribe themselves as they become visible.
    for (final listener in _listeners.toList()) {
      listener();
    }
  }
}

class _ScrollRevealScopeState extends State<ScrollRevealScope> {
  final _controller = ScrollRevealController();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification ||
            notification is ScrollEndNotification) {
          _controller.notify();
        }
        return false;
      },
      child: _ScrollRevealMarker(
        controller: _controller,
        child: widget.child,
      ),
    );
  }
}

class _ScrollRevealMarker extends InheritedWidget {
  const _ScrollRevealMarker({required this.controller, required super.child});

  final ScrollRevealController controller;

  @override
  bool updateShouldNotify(_ScrollRevealMarker oldWidget) =>
      controller != oldWidget.controller;
}

/// Fades + slides its child in the first time it scrolls into view.
///
/// Requires a [ScrollRevealScope] ancestor. Without one the child is shown
/// immediately rather than staying invisible, so content is never lost.
class FadeInOnScroll extends StatefulWidget {
  const FadeInOnScroll({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offsetY = 40,
  });

  final Widget child;
  final Duration delay;
  final double offsetY;

  @override
  State<FadeInOnScroll> createState() => _FadeInOnScrollState();
}

class _FadeInOnScrollState extends State<FadeInOnScroll> {
  final _key = GlobalKey();

  ScrollRevealController? _scope;
  bool _visible = false;
  bool _subscribed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final scope = ScrollRevealScope.maybeOf(context);
    if (scope == _scope) return;

    _detach();
    _scope = scope;

    if (scope == null) {
      // No scope in the tree: reveal rather than risk invisible content.
      _reveal(immediate: true);
    } else if (!_visible) {
      scope.subscribe(_check);
      _subscribed = true;
    }
  }

  void _detach() {
    if (!_subscribed) return;
    _scope?.unsubscribe(_check);
    _subscribed = false;
  }

  void _check() {
    if (_visible || !mounted) return;

    final renderObject = _key.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final viewportHeight = MediaQuery.sizeOf(context).height;
    final top = renderObject.localToGlobal(Offset.zero).dy;

    // Reveal once the element's top edge rises above 92% of the viewport, and
    // also if it is already scrolled past (top < 0) — e.g. after a jump link.
    if (top < viewportHeight * 0.92) _reveal();
  }

  void _reveal({bool immediate = false}) {
    if (_visible) return;
    _visible = true;
    _detach();

    if (immediate || widget.delay == Duration.zero) {
      if (mounted) setState(() {});
      return;
    }

    Future.delayed(widget.delay, () {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      key: _key,
      offset: _visible ? Offset.zero : Offset(0, widget.offsetY / 100),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
