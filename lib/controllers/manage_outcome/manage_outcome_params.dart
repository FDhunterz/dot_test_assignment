part of 'manage_outcome_controller.dart';

mixin ManageOutcomeParams {
  MaterialXFormController? nama, nominal, typeC, tanggalC;
  SelectData<OutcomeType>? type;
  DateTime? tanggalPengeluaran;
  Outcome? editData;
  List<SelectData<OutcomeType>> listType = [
    SelectData(
      title: 'Makanan',
      id: 'Makanan',
      data: OutcomeType(name: 'Makanan', assetIcon: 'assets/makanan.png', colorhex: Color(0xffF2C94C)),
    ),
    SelectData(
      title: 'Internet',
      id: 'Internet',
      data: OutcomeType(name: 'Internet', assetIcon: 'assets/internet.png', colorhex: Color(0xff56CCF2)),
    ),
    SelectData(
      title: 'Edukasi',
      id: 'Edukasi',
      data: OutcomeType(name: 'Edukasi', assetIcon: 'assets/edukasi.png', colorhex: Color(0xffF2994A)),
    ),
    SelectData(
      title: 'Hadiah',
      id: 'Hadiah',
      data: OutcomeType(name: 'Hadiah', assetIcon: 'assets/hadiah.png', colorhex: Color(0xffEB5757)),
    ),
    SelectData(
      title: 'Transport',
      id: 'Transport',
      data: OutcomeType(name: 'Transport', assetIcon: 'assets/transport.png', colorhex: Color(0xff9B51E0)),
    ),
    SelectData(
      title: 'Belanja',
      id: 'Belanja',
      data: OutcomeType(name: 'Belanja', assetIcon: 'assets/belanja.png', colorhex: Color(0xff27AE60)),
    ),
    SelectData(
      title: 'Alat Rumah',
      id: 'Alat Rumah',
      data: OutcomeType(name: 'Alat Rumah', assetIcon: 'assets/alat_rumah.png', colorhex: Color(0xffBB6BD9)),
    ),
    SelectData(
      title: 'Olahraga',
      id: 'Olahraga',
      data: OutcomeType(name: 'Olahraga', assetIcon: 'assets/olahraga.png', colorhex: Color(0xff2D9CDB)),
    ),
    SelectData(
      title: 'Hiburan',
      id: 'Hiburan',
      data: OutcomeType(name: 'Hiburan', assetIcon: 'assets/hiburan.png', colorhex: Color(0xff2F80ED)),
    ),
  ];

  get _controller => ManageOutcomeController.state;

  initParams() {
    nama = MaterialXFormController();
    nominal = MaterialXFormController();
    typeC = MaterialXFormController().changeSuffix(
      Padding(
        padding: EdgeInsetsGeometry.only(left: 4),
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(color: Color(0xffE0E0E0), shape: BoxShape.circle),
          child: Center(child: Icon(Icons.chevron_right, color: Color(0xff828282))),
        ),
      ),
    );
    tanggalC = MaterialXFormController();
    type = SelectData(
      title: 'Makanan',
      id: 'Makanan',
      data: OutcomeType(name: 'Makanan', assetIcon: 'assets/makanan.png', colorhex: Color(0xffF2C94C)),
    );

    tanggalC?.changeSuffix(
      Padding(
        padding: EdgeInsetsGeometry.only(left: 4),
        child: ImageIcon(AssetImage('assets/calendar.png'), size: 20, color: Color(0xffBDBDBD)),
      ),
    );
    nominal?.changePrefix(Padding(padding: EdgeInsetsGeometry.only(right: 4), child: Text('Rp. ')));
    tanggalPengeluaran = DateTime.now();
    initEditParams();
    typeC?.controller.text = type?.title ?? '';
    typeC?.changePrefix(Padding(padding: EdgeInsets.only(right: 8), child: type?.data?.iconOutline ?? SizedBox()));
    MainController.state.fresher.refresh();
  }

  initEditParams() {
    if (editData == null) return;
    nama!.controller.text = editData?.name ?? '';
    tanggalPengeluaran = editData?.date;
    tanggalC?.controller.text = tanggalPengeluaran?.localizedEEEEDDMMMMY();
    type = listType.where((d) => d.title == editData?.type?.name).firstOrNull;
    nominal!.controller.text = intToCurrency(editData?.price?.toInt() ?? 0);
  }

  disposeParams() {
    Future.delayed(Duration(milliseconds: 600), () {
      nominal?.dispose();
      nama?.dispose();
      typeC?.dispose();
      tanggalC?.dispose();
    });
  }
}
