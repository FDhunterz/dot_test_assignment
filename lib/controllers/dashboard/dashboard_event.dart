part of 'dashboard_controller.dart';

extension DashboardEventExtention on DashboardController {
  Future<void> getData() async {
    datas.clear();
    final d = await OutcomeDatabase.get();
    for (var i in d) {
      final outcome = Outcome.fromJson(i);
      datas.add(outcome);
    }
    splitCategorys();
    splitDateGroup();
    MainController.state.fresher.refresh();
  }
}
