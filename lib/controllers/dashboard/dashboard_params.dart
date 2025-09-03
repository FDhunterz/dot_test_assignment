part of 'dashboard_controller.dart';

mixin DashboardParams {
  List<Outcome> datas = [];
  List<DateGroup> datasGroup = [];
  Map<String, List<Outcome>> splitCategory = {};

  initparams() {
    datas.clear();
  }
}
