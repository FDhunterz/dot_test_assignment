import 'package:dot_test/controllers/dashboard/dashboard_controller.dart';
import 'package:dot_test/models/obj.dart';
import 'package:flutter/material.dart';
import 'package:sql_query/viewer/part/currency.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key});

  Widget cardWidget(context, Obj data) {
    final size = MediaQuery.of(context).size.width * .5 - (50 / 2);
    return Container(
      width: size,
      decoration: BoxDecoration(color: data.prop, borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(
                data.title,
                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Rp. ${intToCurrency(data.value.toInt())}',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = DashboardController.state;
    // Mendapatkan awal dan akhir bulan ini
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final listdata = [
      Obj(title: 'Pengeluaranmu hari ini', value: controller.getOutCome(now, null), prop: Color(0xff0A97B0)),
      Obj(
        title: 'Pengeluaranmu bulan ini',
        value: controller.getOutCome(startOfMonth, endOfMonth),
        prop: Color(0xff46B5A7),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Halo, User!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('jangan lupa catat keuanganmu setiap hari!', style: TextStyle(color: Color(0xff828282))),
            ],
          ),
        ),

        SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(spacing: 10, children: [...listdata.map((d) => cardWidget(context, d))]),
        ),
      ],
    );
  }
}
