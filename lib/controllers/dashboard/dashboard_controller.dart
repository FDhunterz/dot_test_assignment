import 'package:dot_test/controllers/main_controller.dart';
import 'package:dot_test/database/model/outcome_database.dart';
import 'package:dot_test/material/date_picker/time.dart';
import 'package:dot_test/models/date_group.dart';
import 'package:dot_test/models/outcome/outcome.dart';
import 'package:dot_test/models/outcome/outcome_type.dart';
import 'package:handlerz/handlerz.dart';
part 'dashboard_event.dart';
part 'dashboard_params.dart';

class DashboardController extends HandlerzController<DashboardController> with DashboardParams {
  DashboardController._state() : super(MainController.state.handlerz);

  static final state = DashboardController._state();

  double getOutCome(DateTime? start, DateTime? end) {
    List<Outcome> datasf;
    if (start != null && end != null) {
      datasf = datas.where((d) {
        final date = d.date?.removeTime();
        final startDate = start.removeTime();
        final endDate = end.removeTime();
        return date != null &&
            (date.isAtSameMomentAs(startDate) || date.isAfter(startDate)) &&
            (date.isAtSameMomentAs(endDate) || date.isBefore(endDate));
      }).toList();
    } else if (start != null) {
      datasf = datas.where((d) => d.date?.removeTime() == start.removeTime()).toList();
    } else {
      datasf = datas;
    }
    double total = 0;
    for (var i in datasf) {
      total += i.price ?? 0;
    }

    return total;
  }

  void splitCategorys() {
    splitCategory.clear();
    final Map<String, List<Outcome>> categoryMap = {};
    for (var outcome in datas) {
      final category = outcome.type?.name ?? '';
      if (category.isNotEmpty) {
        if (!categoryMap.containsKey(category)) {
          categoryMap[category] = [];
        }
        categoryMap[category]?.add(outcome);
      }
    }
    splitCategory = categoryMap;
  }

  void splitDateGroup() {
    datasGroup.clear();
    final Map<DateTime, List<Outcome>> groupByDate = {};

    for (final outcome in datas) {
      final DateTime? date = outcome.date?.removeTime();
      if (date == null) continue;
      groupByDate.putIfAbsent(date, () => <Outcome>[]).add(outcome);
    }

    // Urutkan tanggal grup dari terbaru ke terlama
    final List<DateTime> sortedDates = groupByDate.keys.toList()..sort((a, b) => b.compareTo(a));

    // Opsional: urutkan anak per grup (terbaru ke lama)
    final List<DateGroup<Outcome>> groups = [];
    for (final date in sortedDates) {
      final children = groupByDate[date]!
        ..sort((a, b) {
          final da = a.date ?? date;
          final db = b.date ?? date;
          return db.compareTo(da);
        });
      groups.add(DateGroup<Outcome>(date: date, children: children));
    }

    datasGroup = groups;
  }

  double getTotalByCategory(OutcomeType d) {
    double total = 0;
    for (Outcome? i in splitCategory[d.name] ?? []) {
      total += i?.price ?? 0;
    }

    return total;
  }

  init() {
    initparams();
    getData();
  }
}
