import 'package:dot_test/controllers/dashboard/dashboard_controller.dart';
import 'package:dot_test/controllers/manage_outcome/manage_outcome_controller.dart';
import 'package:dot_test/material/helper/currency.dart';
import 'package:dot_test/models/outcome/outcome_type.dart';
import 'package:flutter/material.dart';

class DashboardOutcomeCard extends StatelessWidget {
  const DashboardOutcomeCard({super.key});

  Widget cardItems(OutcomeType data, {index, total}) {
    final controller = DashboardController.state;
    final total = controller.getTotalByCategory(data);
    if (total == 0) {
      return SizedBox();
    }
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: Container(
        width: 120,
        height: 120,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 4,
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(shape: BoxShape.circle, color: data.colorhex),
              child: data.iconOutlineWhite,
            ),
            SizedBox(height: 6),
            Text(
              data.name ?? '',
              style: TextStyle(fontSize: 12, color: Color(0xff828282)),
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Text(
              'Rp. ${intToCurrency(total.toInt())}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff333333)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Pengeluaran berdasarkan kategori', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              children: [
                SizedBox(width: 20),
                ...ManageOutcomeController.state.listType.map((d) => cardItems(d.data!)),
                // SizedBox(width: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
