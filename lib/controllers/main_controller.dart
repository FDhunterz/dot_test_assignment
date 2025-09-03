import 'dart:io';

import 'package:dot_test/controllers/auth/auth_controller.dart';
import 'package:dot_test/material/fresher/fresh.dart' show Fresh;
import 'package:dot_test/material/route/route.dart' show MyRouteInformationParser, MyRoutePath;
import 'package:dot_test/material/route/route_delegate.dart' show MyRouterDelegate;
import 'package:dot_test/models/profile.dart';
import 'package:flutter/material.dart' show BuildContext, ThemeMode, light;
import 'package:handlerz/handlerz.dart';

class MainController {
  MainController._state();
  static final state = MainController._state();
  Profile profile = Profile();
  ThemeMode themeMode = ThemeMode.light;

  Handlerz handlerz = Handlerz();
  static String appVersion = '1.0.0';
  Fresh<bool> fresher = Fresh(false);

  final routerDelegate = MyRouterDelegate();
  final routeInformationParser = MyRouteInformationParser();
  BuildContext? get context => routerDelegate.navigatorKey.currentContext;

  void back() {
    routerDelegate.back();
  }

  void addRoute(MyRoutePath routePath) {
    routerDelegate.addRoute(routePath);
  }

  void route(MyRoutePath routePath) {
    routerDelegate.setNewRoutePath(routePath);
  }

  void pushAndRemoveAll(MyRoutePath routePath) {
    routerDelegate.pushAndRemoveAll(routePath);
  }

  void addDispose(String path, Function function) {
    routerDelegate.addDispose(path, function);
  }

  void removeDispose(path) {
    routerDelegate.removeDispose(path);
  }

  Future<void> init() async {
    await handlerz.set(
      [],
      firebaseConfig: FirebaseConfig(
        projectId: 'my-project-1538130983896',
        credentialsPath: 'assets/images/my-project-1538130983896-aad8aeeaf62d.json',
        targetToken:
            'f5UGcgWDQiK8uIlIQ8EUkw:APA91bGEYLEwIw4cTB9HK8IjbtBOb4eWLl8C2Hwg_a5nrDQcn_PvkAFYlE2DZeCYgyE4MCqX0NxBV7_9r_Y1xFq5XWUADECI6ELI8MVh2qkwSJs7WvVdor8rt7',
        config: {
          'name': 'RenovDulu',
          'version': MainController.appVersion,
          'author': 'RenovDulu',
          'description': 'RenovDulu',
          'package': 'com.renovdulu.app',
          'token':
              'f5UGcgWDQiK8uIlIQ8EUkw:APA91bGEYLEwIw4cTB9HK8IjbtBOb4eWLl8C2Hwg_a5nrDQcn_PvkAFYlE2DZeCYgyE4MCqX0NxBV7_9r_Y1xFq5XWUADECI6ELI8MVh2qkwSJs7WvVdor8',
          'platform': Platform.isAndroid ? 'android' : 'ios',
        },
      ),
    );

    Future.delayed(Duration(milliseconds: 2000), () {
      MainController.state.route(MyRoutePath.dashboard());
    });
  }

  Future<void> logout() async {
    AuthController.state.logout();
  }
}
