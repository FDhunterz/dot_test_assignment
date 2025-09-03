import 'package:dot_test/controllers/main_controller.dart';
import 'package:dot_test/material/button/button.dart';
import 'package:dot_test/material/route/route.dart';
import 'package:dot_test/view/dashboard/dashboard_card.dart';
import 'package:dot_test/view/dashboard/dashboard_history.dart';
import 'package:dot_test/view/dashboard/dashboard_outcome_card.dart';
import 'package:flutter/material.dart';

class DashboardBase extends StatelessWidget {
  const DashboardBase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 100),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    DashboardCard(),
                    SizedBox(height: 20),
                    DashboardOutcomeCard(),
                    SizedBox(height: 20),
                    DashboardHistory(),
                    SizedBox(height: MediaQuery.of(context).padding.bottom),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: MaterialXButton(
                onTap: () {
                  MainController.state.route(MyRoutePath.manageOutcome());
                },
                isCircle: true,
                color: Color(0xff0A97B0),
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
