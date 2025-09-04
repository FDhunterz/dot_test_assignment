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

  hapus(Outcome data) async {
    final dashboardC = DashboardController.state;

    final d = await OutcomeDatabase.delete(data);
    if (d.firstOrNull?['status'] == 'success') {
      dashboardC.get((d) {
        d.datas.remove(data);
      });

      showToast(message: 'Berhasil Menghapus data', title: 'Berhasil', status: ToastStatus.success);
      DashboardController.state.splitCategorys();
      DashboardController.state.splitDateGroup();

      MainController.state.back();
    }
  }

  update(Outcome data) async {
    final d = await OutcomeDatabase.update(
      Outcome(
        name: nama?.text ?? '',
        date: tanggalPengeluaran,
        price: toDoubleSafe(nominal?.text.replaceAll('.', '')),
        type: type?.data,
        id: data.id,
      ),
    );
    if (d.firstOrNull?['status'] == 'success') {
      showToast(message: 'Berhasil Mengubah data', title: 'Berhasil', status: ToastStatus.success);
      DashboardController.state.getData();

      MainController.state.back();
    }
  }
}
