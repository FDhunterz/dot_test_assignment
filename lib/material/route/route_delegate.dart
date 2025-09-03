import 'package:dot_test/view/dashboard/dashboard_base.dart';
import 'package:dot_test/material/router/animation.dart';
import 'package:dot_test/material/route/route.dart';
import 'package:dot_test/view/manage/outcome/manage_outcome_base.dart';
import 'package:dot_test/view/splash.dart' show SplashView;
import 'package:flutter/material.dart';

class MyRouterDelegate extends RouterDelegate<MyRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRoutePath> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  Map<String, Function> disposeList = {};
  String? _route;
  MyRoutePath? _myRoutePath;
  final List<MyRoutePath> _routepathHistory = [];
  final List<String> _routeHistory = [];

  void addDispose(path, function) {
    if (disposeList[path] != null) {
      disposeList[path] = function;
    } else {
      disposeList.addAll({'$path': function});
    }
  }

  void removeDispose(path) {
    disposeList.removeWhere((e, v) => e == path);
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  Future<bool> back() async {
    if (_routeHistory.isNotEmpty) {
      // Hapus route saat ini dari history
      if (_route != null) MyRoutePath.disposePath(_route!, disposeList);

      _routeHistory.removeLast();
      _routepathHistory.removeLast();
      // if (_routepathHistory.isNotEmpty) _routepathHistory.last.init();
      // Ambil route sebelumnya
      if (_routeHistory.isNotEmpty) {
        _route = _routeHistory.last;
      } else {}

      notifyListeners();
      return true;
    }
    return false; // Tidak ada history untuk kembali
  }

  // Fungsi untuk mengecek apakah bisa kembali
  bool canGoBack() {
    return _routeHistory.isNotEmpty;
  }

  // Fungsi untuk mendapatkan route sebelumnya
  String? getPreviousRoute() {
    if (_routeHistory.length > 1) {
      return _routeHistory[_routeHistory.length - 2];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_route == null || _route == 'splash') CustomPage(key: const ValueKey('splash'), child: SplashView()),
        if (_route == 'dashboard') CustomPage(key: const ValueKey('dashboard'), child: DashboardBase()),
        if (_route == 'manage.outcome') CustomPage(key: const ValueKey('manage.outcome'), child: ManageOutcomeBase()),
        if (_route == 'notfound')
          CustomPage(
            key: const ValueKey('notfound'),
            child: Scaffold(
              body: Column(
                children: [
                  SizedBox(height: 50),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          back();
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                    ],
                  ),
                  Expanded(child: Center(child: Text('404'))),
                ],
              ),
            ),
          ),
      ],
      onDidRemovePage: (page) {},
    );
  }

  Future<void> pushAndRemoveAll(MyRoutePath path) async {
    // Tambahkan route ke history jika berbeda dengan route saat ini

    for (var i in _routepathHistory) {
      MyRoutePath.disposePath(i.path, disposeList);
    }

    if (_myRoutePath != null) {
      MyRoutePath.disposePath(_route!, disposeList);
    }

    if (_route != path.path) {
      if (_route != null) {
        _routeHistory.add(path.path);
        _routepathHistory.add(path);
      }
    }

    _myRoutePath = path;
    _route = path.path;

    notifyListeners();
  }

  Future<void> addRoute(MyRoutePath path) async {
    if (_route != path.path) {
      _routeHistory.add(path.path);
      _routepathHistory.add(path);
    }

    _myRoutePath = path;
    _route = path.path;
  }

  @override
  Future<void> setNewRoutePath(MyRoutePath path) async {
    // Tambahkan route ke history jika berbeda dengan route saat ini
    if (_route != path.path) {
      if (_route != null) {
        _routeHistory.add(path.path);
        _routepathHistory.add(path);
      }
    }

    _myRoutePath = path;
    _route = path.path;

    notifyListeners();
  }
}
