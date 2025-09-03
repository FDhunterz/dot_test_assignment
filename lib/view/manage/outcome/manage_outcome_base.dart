import 'package:dot_test/controllers/main_controller.dart';
import 'package:dot_test/controllers/manage_outcome/manage_outcome_controller.dart';
import 'package:dot_test/material/base_widget/base_widget.dart';
import 'package:dot_test/material/button/button.dart';
import 'package:dot_test/material/fresher/fresher.dart';
import 'package:dot_test/view/manage/outcome/manage_outcome_form.dart';
import 'package:flutter/material.dart';

class ManageOutcomeBase extends StatelessWidget {
  const ManageOutcomeBase({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ManageOutcomeController.state;
    return Scaffold(
      body: SafeArea(
        child: InitControl(
          child: SingleChildScrollView(
            child: Column(
              children: [
                NoSplashButton(
                  onTap: () {
                    MainController.state.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Icon(Icons.chevron_left, size: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            controller.editData == null
                                ? 'Tambah Pengeluaran Baru'
                                : 'Detail ${controller.editData?.name}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ManageOutcomeForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
