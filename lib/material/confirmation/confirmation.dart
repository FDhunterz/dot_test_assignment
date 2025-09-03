import 'package:dot_test/material/button/button.dart';
import 'package:dot_test/material/env/color.dart';
import 'package:dot_test/material/popup/bottom.dart';

import '../api/api_helper/navigator_helper.dart';
import 'package:flutter/material.dart';
import '../api/api_helper/model/global_env.dart';

// class CIcon {}

confirmation({message, title}) async {
  final scrollController = ScrollController();

  final d = await showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: ENV.navigatorKey.currentContext!,
    elevation: 0,
    builder: (context) {
      return bottom(
        scrollController: scrollController,
        context: context,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(title ?? 'Are you sure?', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Text(message ?? '', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: NoSplashButton(
                    onTap: () {
                      Navigate.pop();
                    },
                    child: const Center(child: Text('No')),
                  ),
                ),
                Expanded(
                  child: MaterialXButton(
                    onTap: () {
                      Navigate.pop(true, true);
                    },
                    color: Colors.redAccent,
                    title: 'Yes',
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );

  scrollController.dispose();

  return d;
}

Future<bool?> confirmationAlert({
  message,
  title,
  accButton,
  icon,
  cancelButton,
  dissmissable = true,
  onlyAccButton = false,
  removeButton = false,
  isError = false,
  Widget? customContent,
  String? header,
  accButtonColor,
  cancelButtonColor,
}) async {
  return (await showDialog(
    context: ENV.navigatorKey.currentContext!,
    barrierDismissible: dissmissable,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        // surfaceTintColor: Colors.white,
        backgroundColor: ColorApps.bgColorPrimary, // Mengubah warna background menjadi abu-abu
        contentPadding: message == null ? EdgeInsets.zero : const EdgeInsets.only(left: 16, right: 16, top: 16),
        actionsPadding: removeButton
            ? EdgeInsets.only(bottom: 16)
            : const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 24),
        titlePadding: title == null
            ? const EdgeInsets.only(bottom: 8)
            : header != null
            ? const EdgeInsets.only(top: 0)
            : const EdgeInsets.only(top: 16, left: 16, right: 16),
        title: title == null
            ? const SizedBox()
            : Column(
                children: [
                  header != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  header,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ColorApps.textPrimary,
                                  ),
                                ),
                              ),
                              NoSplashButton(
                                child: Icon(Icons.close, color: ColorApps.textPrimary, size: 24),
                                onTap: () {
                                  Navigate.pop(false, null);
                                },
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  header != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Divider(color: ColorApps.formBorder, height: 0),
                        )
                      : const SizedBox(),

                  icon != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Center(child: icon),
                        )
                      : const SizedBox(),
                  icon != null ? const SizedBox(height: 16) : const SizedBox(),
                  Text(
                    title ?? 'Are you sure?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ColorApps.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
        content:
            customContent ??
            (message == null
                ? null
                : Text(
                    message ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: title == null ? ColorApps.textPrimary : ColorApps.textSubColor3,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  )),
        actions: [
          removeButton
              ? const SizedBox()
              : SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      onlyAccButton
                          ? const SizedBox()
                          : Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: cancelButtonColor ?? ColorApps.formBorder),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: MaterialXButton(
                                  color: Colors.transparent,
                                  onTap: () {
                                    Navigate.pop(false, false);
                                  },
                                  child: Text(
                                    cancelButton ?? 'Cancel',
                                    style: TextStyle(
                                      color: cancelButtonColor ?? ColorApps.textPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      accButton == null || onlyAccButton ? const SizedBox() : const SizedBox(width: 12),
                      accButton == null
                          ? const SizedBox()
                          : Expanded(
                              child: MaterialXButton(
                                color: accButtonColor ?? ColorApps.bottomNav,
                                borderRadius: BorderRadius.circular(100),
                                onTap: () {
                                  Navigate.pop(false, true);
                                },
                                child: Text(
                                  accButton ?? 'Yes',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
        ],
      );
    },
  ));
}
