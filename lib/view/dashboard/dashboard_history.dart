import 'package:dot_test/controllers/dashboard/dashboard_controller.dart';
import 'package:dot_test/controllers/main_controller.dart';
import 'package:dot_test/material/button/button.dart';
import 'package:dot_test/material/helper/currency.dart';
import 'package:dot_test/material/route/route.dart';
import 'package:dot_test/models/outcome/outcome.dart';
import 'package:flutter/material.dart';

class DashboardHistory extends StatelessWidget {
  const DashboardHistory({super.key});

  Widget cardWidget(Outcome data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(offset: Offset(0, 4), blurRadius: 8, spreadRadius: 4, color: Colors.black.withValues(alpha: 0.08)),
        ],
      ),
      child: Row(
        children: [
          data.type?.iconOutline ?? SizedBox(),
          SizedBox(width: 12),
          Expanded(child: Text(data.name ?? '')),
          SizedBox(width: 12),
          Text('Rp. ${intToCurrency(data.price?.toInt() ?? 0)}', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = DashboardController.state;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.datasGroup.length,

            itemBuilder: (context, index) {
              final data = controller.datasGroup[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.humanizeDate(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.children.length,
                    itemBuilder: (context, index) {
                      final data2 = data.children[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: NoSplashButton(
                          onTap: () {
                            MainController.state.route(MyRoutePath.manageOutcome(editData: data2));
                          },
                          child: cardWidget(data2),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
