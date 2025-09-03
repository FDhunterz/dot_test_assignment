import 'dart:async';
import 'package:dot_test/controllers/main_controller.dart';
import 'package:dot_test/material/popup/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoClass extends StatelessWidget {
  const NoClass({super.key});
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

DateTime? currentNow;
Timer? timer;

_doubleClick() {
  if (currentNow == null) {
    showToast(title: 'Close App', message: 'Double Click to Close App', status: ToastStatus.warning);
    currentNow = DateTime.now();
    timer = Timer(const Duration(milliseconds: 1000), () {
      currentNow = null;
    });
  } else {
    timer?.cancel();
    if (currentNow!.difference(DateTime.now()).inMilliseconds < 1000) {
      SystemNavigator.pop();
    }
  }
}

class InitControl extends StatelessWidget {
  final Widget? child;
  final bool? doubleClick;
  final Duration? delayPop;
  final bool? safeArea;
  final VoidCallback? onTapScreen;
  final Function? onBackPressed;
  final Widget? baseClass;

  const InitControl({
    super.key,
    this.child,
    this.doubleClick,
    this.safeArea,
    this.onTapScreen,
    this.delayPop,
    this.onBackPressed,
    this.baseClass,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          final lastRoute = Navigator.of(context).canPop();
          final lastRoutes = MainController.state.routerDelegate.canGoBack();
          if (!lastRoute && !lastRoutes) {
            if (result != 'escape_double_click') {
              _doubleClick();
            }
          } else {
            if (onBackPressed != null) {
              onBackPressed!();
            } else {
              MainController.state.back();
              // Navigator.of(context).pop();
            }
          }
        }
      },
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                final FocusScopeNode currentScope = FocusScope.of(context);
                if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                  FocusManager.instance.primaryFocus!.unfocus();
                }
                SystemChrome.restoreSystemUIOverlays();
                if (onTapScreen != null) {
                  onTapScreen!();
                }
              },
              child: child!,
            ),
          ),
          // Fresher(
          //   listener: MainController.state.isLoading,
          //   builder: (v, s) {
          //     if (!v) {
          //       return const SizedBox();
          //     }
          //     return Positioned(
          //       right: 10,
          //       bottom: 10,
          //       child: Image.asset(
          //         'asset/loading.gif',
          //         width: 30,
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
