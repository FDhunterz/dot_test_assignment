import 'package:flutter/material.dart';

/// WidgetTransitionFade
///
/// Widget ini memberikan efek fade in dan fade out pada child-nya.
/// Ketika [visible] diubah menjadi false, widget akan fade out terlebih dahulu sebelum menghilang dari pohon widget.
class WidgetTransitionFade extends StatefulWidget {
  final Widget child;
  final bool visible;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onFadeComplete;

  const WidgetTransitionFade({
    Key? key,
    required this.child,
    required this.visible,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.onFadeComplete,
  }) : super(key: key);

  @override
  State<WidgetTransitionFade> createState() => _WidgetTransitionFadeState();
}

class _WidgetTransitionFadeState extends State<WidgetTransitionFade> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _shouldShow = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    if (widget.visible) {
      _controller.value = 1.0;
    } else {
      _controller.value = 0.0;
      _shouldShow = false;
    }
  }

  @override
  void didUpdateWidget(covariant WidgetTransitionFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        setState(() {
          _shouldShow = true;
        });
        _controller.forward();
      } else {
        _controller.reverse().then((_) {
          if (mounted) {
            setState(() {
              _shouldShow = false;
            });
            widget.onFadeComplete?.call();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShow) return const SizedBox.shrink();
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}
