import 'package:dot_test/material/animation/animation.dart';
import 'package:dot_test/material/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget bottom({
  child,
  Widget? customChild,
  double? maxHeight,
  String? title,
  bool headerAnimation = true,
  Color? backgroundTitleColor,
  bool full = false,
  onScreenTap,
  disableScreenTap = false,
  required BuildContext context,
  required ScrollController scrollController,
  Function? addResetHeader,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
    child: SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        primary: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * (maxHeight ?? 0.95),
                child: GestureDetector(
                  onTap: disableScreenTap
                      ? null
                      : () {
                          if (onScreenTap != null) {
                            onScreenTap();
                          }
                          final FocusScopeNode currentScope = FocusScope.of(context);
                          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          }
                          SystemChrome.restoreSystemUIOverlays();
                        },
                  child: Column(
                    mainAxisSize: full ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      !full
                          ? Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    title != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(top: 12.0),
                                            child: headerAnimation
                                                ? addResetHeader != null
                                                      ? Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            HeaderAnimation(
                                                              scrollController: scrollController,
                                                              title: title,
                                                            ),
                                                            NoSplashButton(
                                                              onTap: () {
                                                                addResetHeader();
                                                              },
                                                              child: Text(
                                                                'Reset',
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : HeaderAnimation(
                                                          scrollController: scrollController,
                                                          title: title,
                                                        )
                                                : Text(
                                                    title,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                          )
                                        : const SizedBox(),
                                    Flexible(
                                      child:
                                          customChild ??
                                          SingleChildScrollView(
                                            controller: scrollController,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[child ?? const SizedBox()],
                                                ),
                                              ),
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                  ),
                                ),
                                child: SizedBox(
                                  height: (MediaQuery.of(context).size.height * (maxHeight ?? 1)) - 300,
                                  child: Column(
                                    children: [
                                      title != null
                                          ? Padding(
                                              padding: const EdgeInsets.only(top: 12),
                                              child: HeaderAnimation(scrollController: scrollController, title: title),
                                            )
                                          : const SizedBox(),
                                      customChild ??
                                          SingleChildScrollView(
                                            controller: scrollController,
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[child ?? const SizedBox()],
                                              ),
                                            ),
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
