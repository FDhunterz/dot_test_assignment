import 'package:dot_test/material/api/api_helper/model/global_env.dart';
import 'package:dot_test/material/button/button.dart';
import 'package:dot_test/material/date_picker/date_picker.dart';
import 'package:dot_test/material/popup/bottom.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showXDatePicker({title, start, end, initialDate, disableTime = false, onlyTime = false}) async {
  initialDate ??= DateTime.now();
  final controller = XDatePickerController(targetDate: initialDate);
  DateTime? date;
  final scrollController = ScrollController();

  await showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: ENV.navigatorKey.currentContext!,
    builder: (context) {
      return bottom(
        scrollController: scrollController,
        maxHeight: 0.90,
        full: false,
        title: title ?? 'Pick-up Date',
        context: context,
        customChild: StatefulBuilder(
          builder: (context, s) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: SizedBox(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            XDatePicker(
                              onSelect: (date) {
                                s(() {});
                              },
                              controller: controller,
                              startDate: start,
                              endDate: end,
                              withTime: !disableTime,
                              timeOnly: onlyTime,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  MaterialXButton(
                    active: controller.selectedDate != null,
                    onTap: () {
                      date = DateTime(
                        controller.selectedDate?.year ?? 0,
                        controller.selectedDate?.month ?? 0,
                        controller.selectedDate?.day ?? 0,
                        controller.selectedTime!.hour,
                        controller.selectedTime!.minute,
                      );
                      Navigator.pop(context);
                    },
                    title: 'Apply',
                    // child: const Text('Apply'),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            );
          },
        ),
      );
    },
  );
  scrollController.dispose();
  controller.dispose();
  return date;
}
