import 'package:dot_test/controllers/dashboard/dashboard_controller.dart';
import 'package:dot_test/controllers/main_controller.dart';
import 'package:dot_test/database/model/outcome_database.dart';
import 'package:dot_test/material/api/api_helper/model/global_env.dart';
import 'package:dot_test/material/date_picker/picker.dart';
import 'package:dot_test/material/form/materialxformcontroller.dart';
import 'package:dot_test/material/helper/currency.dart';
import 'package:dot_test/material/popup/toast.dart';
import 'package:dot_test/material/select/select.dart';
import 'package:dot_test/material/date_picker/time.dart';
import 'package:dot_test/models/outcome/outcome.dart';
import 'package:dot_test/models/outcome/outcome_type.dart';
import 'package:dot_test/view/manage/outcome/manage_outcome_select_type.dart';
import 'package:flutter/material.dart';
import 'package:handlerz/handlerz.dart';
import 'package:sql_query/viewer/controller/sql_viewer_controller.dart';
part 'manage_outcome_event.dart';
part 'manage_outcome_params.dart';
part 'manage_outcome_validation.dart';

class ManageOutcomeController extends HandlerzController<ManageOutcomeController> with ManageOutcomeParams {
  ManageOutcomeController._state() : super(MainController.state.handlerz);

  static final state = ManageOutcomeController._state();

  Future<SelectData<OutcomeType>?> selectType() async {
    return await getAsync((d) async {
      final scrollController = ScrollController();

      final d = await showModalBottomSheet<SelectData<OutcomeType>?>(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: ENV.navigatorKey.currentContext!,
        builder: (context) {
          return ManageOutcomeSelectType(scrollController: scrollController);
        },
      );
      Future.delayed(Duration(milliseconds: 600), () {
        scrollController.dispose();
      });

      if (d != null) {
        type = d;
        typeC?.controller.text = d.title ?? '';
        typeC?.changePrefix(Padding(padding: EdgeInsets.only(right: 8), child: d.data?.iconOutline ?? SizedBox()));
        MainController.state.fresher.refresh();
      }
      return d;
    });
  }

  Future<void> selectDate() async {
    final d = await showXDatePicker(
      title: 'Tanggal Pengeluaran',
      start: DateTime(2000),
      end: DateTime.now(),
      disableTime: true,
    );
    if (d != null) {
      tanggalPengeluaran = d;
      tanggalC?.controller.text = d.localizedEEEEDDMMMMY();
    }
    MainController.state.fresher.refresh();
  }

  init({Outcome? editData}) {
    this.editData = editData;
    initParams();
  }

  dispose() {
    disposeParams();
  }
}
