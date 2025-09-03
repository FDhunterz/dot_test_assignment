import 'package:dot_test/material/api/api_helper/model/global_env.dart';
import 'package:flutter/material.dart';

class NoSplashButton extends StatelessWidget {
  final Widget child;
  final Function()? onTap;
  final Function()? onLongPress;
  const NoSplashButton({super.key, required this.child, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }
}

class MaterialXButton extends StatelessWidget {
  final String? title;
  final Color? color;
  final Color? textColor;
  final Function? onTap;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final bool? active;
  final bool isCircle;
  final BorderRadius? borderRadius;
  const MaterialXButton({
    super.key,
    this.title = '',
    this.onTap,
    this.color,
    this.textColor,
    this.child,
    this.padding,
    this.active,
    this.isCircle = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    bool haveActive = false;
    bool actives = true;
    if (active != null) {
      haveActive = true;
      actives = active!;
    }
    return Material(
      color: Colors.transparent,
      borderRadius: isCircle ? null : const BorderRadius.all(Radius.circular(12)),
      child: Material(
        color: !haveActive
            ? (color ?? Color(0xff3DBC81))
            : (actives ? (color ?? Color(0xff3DBC81)) : color ?? Color(0xffE0E0E0)),
        type: isCircle ? MaterialType.circle : MaterialType.card,
        borderRadius: isCircle ? null : borderRadius ?? const BorderRadius.all(Radius.circular(12)),
        child: InkWell(
          borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(isCircle ? 200 : 12)),
          onTap: !actives || onTap == null
              ? null
              : () {
                  try {
                    final FocusScopeNode currentScope = FocusScope.of(ENV.navigatorKey.currentContext!);
                    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    }
                  } catch (_) {}
                  if (onTap != null) {
                    onTap!();
                  }
                },
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12),
            child: Center(
              child:
                  child ??
                  Text(
                    '$title',
                    style: TextStyle(
                      color: !haveActive
                          ? (textColor ?? Colors.white)
                          : (actives ? (textColor ?? Colors.white) : Colors.white),
                      fontSize: 14,
                      fontWeight: color == Colors.transparent ? FontWeight.w800 : FontWeight.w700,
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
