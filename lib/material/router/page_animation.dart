import 'package:dot_test/material/router/animation.dart';
import 'package:flutter/material.dart';

class CustomPage extends Page {
  final Widget child;
  final TransitionType transitionType;

  const CustomPage({required LocalKey key, required this.child, this.transitionType = TransitionType.fade})
    : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    switch (transitionType) {
      case TransitionType.none:
        return MaterialPageRoute(settings: this, builder: (_) => child);
      case TransitionType.fade:
        return FadePageRoute(settings: this, child: child);
      case TransitionType.slide:
        return SlidePageRoute(settings: this, child: child);
      case TransitionType.scale:
        return ScalePageRoute(settings: this, child: child);
    }
  }
}
