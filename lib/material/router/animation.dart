import 'package:dot_test/material/base_widget/base_widget.dart';
import 'package:flutter/material.dart';

enum TransitionType { none, fade, slide, scale }

class CustomPage extends Page {
  final Widget child;
  final TransitionType transitionType;

  const CustomPage({required LocalKey key, required this.child, this.transitionType = TransitionType.fade})
    : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    switch (transitionType) {
      case TransitionType.none:
        return MaterialPageRoute(
          settings: this,
          builder: (_) => InitControl(disableOnPop: false, doubleClick: true, child: child),
        );
      case TransitionType.fade:
        return FadePageRoute(
          settings: this,
          child: InitControl(disableOnPop: false, doubleClick: true, child: child),
        );
      case TransitionType.slide:
        return SlidePageRoute(
          settings: this,
          child: InitControl(disableOnPop: false, doubleClick: true, child: child),
        );
      case TransitionType.scale:
        return ScalePageRoute(
          settings: this,
          child: InitControl(disableOnPop: false, doubleClick: true, child: child),
        );
    }
  }
}

class FadePageRoute extends PageRouteBuilder {
  final Widget child;

  FadePageRoute({required RouteSettings settings, required this.child})
    : super(
        settings: settings,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return child;
        },
        transitionsBuilder:
            (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return FadeTransition(opacity: animation, child: child);
            },
        transitionDuration: const Duration(milliseconds: 300),
      );
}

class SlidePageRoute extends PageRouteBuilder {
  final Widget child;

  SlidePageRoute({required RouteSettings settings, required this.child})
    : super(
        settings: settings,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return child;
        },
        transitionsBuilder:
            (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(position: animation.drive(tween), child: child);
            },
        transitionDuration: const Duration(milliseconds: 300),
      );
}

class ScalePageRoute extends PageRouteBuilder {
  final Widget child;

  ScalePageRoute({required RouteSettings settings, required this.child})
    : super(
        settings: settings,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return child;
        },
        transitionsBuilder:
            (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return ScaleTransition(
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
                child: child,
              );
            },
        transitionDuration: const Duration(milliseconds: 400),
      );
}
