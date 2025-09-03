import 'package:dot_test/controllers/main_controller.dart';
import 'package:dot_test/controllers/manage_outcome/manage_outcome_controller.dart';
import 'package:dot_test/material/button/button.dart';
import 'package:dot_test/material/date_picker/picker.dart';
import 'package:dot_test/material/form/materialxform.dart';
import 'package:dot_test/material/fresher/fresher.dart';
import 'package:flutter/material.dart';

class ManageOutcomeForm extends StatelessWidget {
  const ManageOutcomeForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ManageOutcomeController.state;
    return Fresher(
      listener: MainController.state.fresher,
      builder: (v, s) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              MaterialXForm(
                onChanged: (d) {
                  MainController.state.fresher.refresh();
                },
                controller: controller.nama,
                hintText: 'Nama Pengeluaran',
              ),
              SizedBox(height: 20),
              MaterialXForm(
                controller: controller.typeC,
                hintText: 'Makanan',
                isEnabled: false,
                onTap: () {
                  controller.selectType();
                },
              ),
              SizedBox(height: 20),
              MaterialXForm(
                controller: controller.tanggalC,
                hintText: 'Tanggal Pengeluaran',
                isEnabled: false,
                onTap: () async {
                  controller.selectDate();
                },
              ),
              SizedBox(height: 20),
              MaterialXForm(
                onChanged: (d) {
                  MainController.state.fresher.refresh();
                },
                controller: controller.nominal,
                hintText: 'Nominal',
                isCurrency: true,
              ),
              SizedBox(height: 20),
              if (controller.editData == null)
                MaterialXButton(
                  active: controller.validateAll(),
                  onTap: () {
                    controller.simpan();
                  },
                  title: 'Simpan',
                  color: controller.validateAll() ? Color(0xff0A97B0) : Color(0xffE0E0E0),
                ),
            ],
          ),
        );
      },
    );
  }
}
