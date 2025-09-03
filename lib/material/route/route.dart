import 'package:dot_test/controllers/auth/auth_controller.dart';
import 'package:dot_test/controllers/dashboard/dashboard_controller.dart';
import 'package:dot_test/controllers/main_controller.dart';
import 'package:dot_test/controllers/manage_outcome/manage_outcome_controller.dart';
import 'package:dot_test/material/api/api_helper/session.dart';
import 'package:dot_test/models/outcome/outcome.dart';
import 'package:flutter/material.dart';

class MyRoutePath {
  late String path;
  late Function init;

  static disposePath(String path, Map<String, Function> routeList) {
    final paths = routeList[path];
    if (paths != null) {
      paths();
    }
  }

  MyRoutePath.notfound() {
    path = 'notfound';
  }

  MyRoutePath.dashboard() {
    path = 'dashboard';
    init = DashboardController.state.init;
    init();
  }

  MyRoutePath.manageOutcome({Outcome? editData}) {
    path = 'manage.outcome';
    init = () {
      ManageOutcomeController.state.init(editData: editData);
      // CheckinController.state.init(clockin);
    };
    init();
  }

  MyRoutePath.splash() {
    path = 'splash';
  }
}

class MyRouteInformationParser extends RouteInformationParser<MyRoutePath> {
  @override
  Future<MyRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = routeInformation.uri;
    final token = await Session.load('token');
    await AuthController.state.getProfile();
    MainController.state.profile.token = token;
    if (token != null && MainController.state.profile.token != null) {
      final d = MyRoutePath.dashboard();
      MainController.state.addRoute(d);
      return d;
    } else if (uri.pathSegments.isEmpty) {
      return MyRoutePath.splash();
    } else if (uri.pathSegments[0] == 'dashboard') {
      return MyRoutePath.dashboard();
    }

    return MyRoutePath.splash();
  }

  @override
  RouteInformation? restoreRouteInformation(MyRoutePath path) {
    return RouteInformation(uri: Uri.parse('/'));
  }
}
