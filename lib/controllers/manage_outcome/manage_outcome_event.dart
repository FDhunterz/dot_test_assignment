part of 'manage_outcome_controller.dart';

extension ManageOutcomeEventExtention on ManageOutcomeController {
  simpan() async {
    final dashboardC = DashboardController.state;
    final data = Outcome(
      name: nama?.text ?? '',
      date: tanggalPengeluaran,
      price: toDoubleSafe(nominal?.text.replaceAll('.', '')),
      type: type?.data,
    );

    final d = await OutcomeDatabase.insert(data);
    if (d.firstOrNull?['status'] == 'success') {
      dashboardC.get((d) {
        d.datas.add(data);
      });

      showToast(message: 'Berhasil Menambahkan data', title: 'Berhasil', status: ToastStatus.success);
      DashboardController.state.splitCategorys();
      DashboardController.state.splitDateGroup();

      MainController.state.back();
    }
  }
}
