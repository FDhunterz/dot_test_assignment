import 'package:dot_test/controllers/main_controller.dart';
import 'package:dot_test/material/api/api_helper/model/global_env.dart';
import 'package:dot_test/material/button/button.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

enum ToastStatus { success, error, warning, info }

// Manager untuk mengontrol jumlah toast yang aktif
class ToastManager {
  static int _activeCount = 0;
  static const int _maxToasts = 3;

  static bool canShowToast() {
    return _activeCount < _maxToasts;
  }

  static void incrementCount() {
    _activeCount++;
  }

  static void decrementCount() {
    if (_activeCount > 0) {
      _activeCount--;
    }
  }

  static void resetCount() {
    _activeCount = 0;
  }

  static int get activeCount => _activeCount;
}

// Color _getColorForStatus(ToastStatus? status) {
//   if (status == ToastStatus.success) {
//     return Colors.green;
//   } else if (status == ToastStatus.error) {
//     return Colors.red;
//   } else if (status == ToastStatus.warning) {
//     return Colors.orange;
//   } else if (status == ToastStatus.info) {
//     return Colors.blue;
//   } else {
//     return Colors.grey;
//   }
// }

// showToast({title, message, ToastStatus? status}) {
//   ScaffoldMessenger.of(ENV.navigatorKey.currentContext!).showSnackBar(
//     SnackBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       padding: EdgeInsets.zero,
//       content: Container(
//         margin: const EdgeInsets.all(16),
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: status == ToastStatus.success
//                   ? Color(0xff008000)
//                   : status == ToastStatus.error
//                   ? Color(0xffFF0000)
//                   : Color(0xff000000),
//               width: 1,
//             ),
//             color: status == ToastStatus.success
//                 ? Color(0xffD7FFE3)
//                 : status == ToastStatus.error
//                 ? Color(0xffFFE3E3)
//                 : Color(0xffE3E3E3),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: IntrinsicHeight(
//               child: Row(
//                 children: [
//                   if (status == ToastStatus.success) MaterialXIcons.check,
//                   if (status == ToastStatus.error) MaterialXIcons.close,
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           title ?? '',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: status == ToastStatus.success
//                                 ? Color(0xff008000)
//                                 : status == ToastStatus.error
//                                 ? Color(0xffFF0000)
//                                 : Color(0xff000000),
//                             fontSize: 13,
//                           ),
//                         ),
//                         Text(
//                           message ?? '',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             color: status == ToastStatus.success
//                                 ? Color(0xff008000)
//                                 : status == ToastStatus.error
//                                 ? Color(0xffFF0000)
//                                 : Color(0xff000000),
//                             fontSize: 11,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   NoSplashButton(
//                     onTap: () {
//                       ScaffoldMessenger.of(ENV.navigatorKey.currentContext!).hideCurrentSnackBar();
//                     },
//                     child: Icon(
//                       Icons.close,
//                       color: status == ToastStatus.success
//                           ? Color(0xff008000)
//                           : status == ToastStatus.error
//                           ? Color(0xffFF0000)
//                           : Color(0xff000000),
//                       size: 22,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }

Color _getColorForStatus(ToastStatus? status) {
  if (status == ToastStatus.success) {
    return Color(0xff3DBC81);
  } else if (status == ToastStatus.error) {
    return Color.fromARGB(0, 196, 17, 17);
  } else if (status == ToastStatus.warning) {
    return Color.fromARGB(0, 208, 116, 10);
  } else if (status == ToastStatus.info) {
    return Color.fromARGB(0, 11, 99, 177);
  } else {
    return Colors.grey;
  }
}

void showToast({String? title, String? message, ToastStatus? status, String position = 'top', Function? function}) {
  // Cek apakah masih bisa menampilkan toast
  if (!ToastManager.canShowToast()) {
    // Jika sudah mencapai maksimal, hapus semua toast yang ada
    DelightToastBar.removeAll();
    ToastManager.resetCount();
  }

  // Increment counter
  ToastManager.incrementCount();

  final d = DelightToastBar(
    animationCurve: Curves.easeInOut,
    animationDuration: const Duration(milliseconds: 200),
    position: position == 'bottom' ? DelightSnackbarPosition.bottom : DelightSnackbarPosition.top,
    autoDismiss: true,
    builder: (context) => NoSplashButton(
      onTap: () {
        if (function != null) {
          function()!;
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _getColorForStatus(status), width: 1),
            color: status == ToastStatus.success
                ? Color(0xffD7FFE3)
                : status == ToastStatus.error
                ? Color(0xffFFE3E3)
                : status == ToastStatus.info
                ? Color(0xffE0EBFF)
                : Color.fromARGB(0, 208, 116, 10).withValues(alpha: 0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  if (status == ToastStatus.success) Icon(Icons.check, color: Color(0xff3DBC81)),
                  if (status == ToastStatus.error) Icon(Icons.warning_amber_rounded, color: Color(0xffFF0000)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: status == ToastStatus.success
                                ? Color(0xff008000)
                                : status == ToastStatus.error
                                ? Color(0xffFF0000)
                                : Color(0xff000000),
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          message ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: status == ToastStatus.success
                                ? Color(0xff008000)
                                : status == ToastStatus.error
                                ? Color(0xffFF0000)
                                : Color(0xff000000),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  NoSplashButton(
                    onTap: () {
                      ToastManager.decrementCount();
                      DelightToastBar.removeAll();
                    },
                    child: Icon(Icons.close, size: 22),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  d.show(ENV.navigatorKey.currentContext!);
  MainController.state.fresher.refresh();
}

// Fungsi untuk menghapus semua toast
void removeAllToasts() {
  DelightToastBar.removeAll();
  ToastManager.resetCount();
}
