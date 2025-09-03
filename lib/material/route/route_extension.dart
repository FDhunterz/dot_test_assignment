import 'package:dot_test/material/route/route_delegate.dart';
import 'package:flutter/material.dart';

extension RouteExtension on BuildContext {
  // Fungsi untuk mengakses router delegate dari context
  MyRouterDelegate? get routerDelegate {
    final delegate = Router.of(this).routerDelegate;
    if (delegate is MyRouterDelegate) {
      return delegate;
    }
    return null;
  }

  // Fungsi back yang bisa dipanggil dari context
  Future<bool> goBack() async {
    final delegate = routerDelegate;
    if (delegate != null) {
      return await delegate.back();
    }
    return false;
  }

  // Fungsi untuk mengecek apakah bisa kembali
  bool canGoBack() {
    final delegate = routerDelegate;
    return delegate?.canGoBack() ?? false;
  }

  // Fungsi untuk mendapatkan route sebelumnya
  String? getPreviousRoute() {
    final delegate = routerDelegate;
    return delegate?.getPreviousRoute();
  }
}
