import 'package:dot_test/controllers/main_controller.dart';
import 'package:dot_test/database/model/outcome_database.dart';
import 'package:dot_test/material/api/api_helper/model/global_env.dart';
import 'package:dot_test/material/router/transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:sql_query/builder/query_builder.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ENV.navigatorKey = MainController.state.routerDelegate.navigatorKey;

  Future.delayed(Duration.zero, () async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    initializeDateFormatting();
  });

  await DB.init(databaseName: 'dot_test_database', tableList: [OutcomeDatabase.tables()]);
  MainController.state.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DOT Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {TargetPlatform.android: CustomTransitionBuilder(), TargetPlatform.iOS: CustomTransitionBuilder()},
        ),
      ),
      routerDelegate: MainController.state.routerDelegate,
      routeInformationParser: MainController.state.routeInformationParser,
    );
  }
}
