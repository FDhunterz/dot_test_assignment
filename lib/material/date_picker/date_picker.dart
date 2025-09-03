import 'package:dot_test/material/api/api_helper/model/global_env.dart';
import 'package:dot_test/material/button/button.dart';
import 'package:dot_test/material/date_picker/time.dart';
import 'package:dot_test/material/fresher/fresh.dart';
import 'package:dot_test/material/fresher/fresher.dart';
import 'package:dot_test/material/popup/bottom.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CellDate {
  final String day;
  final DateTime? date;
  final bool isActive;
  final bool isToday;
  final bool isSelected;
  final bool isDisabled;
  final bool isWeekend;
  final bool isHoliday;
  final bool isWeekday;
  final bool isNotTargeted;

  CellDate({
    required this.day,
    this.isActive = false,
    this.isToday = false,
    this.isSelected = false,
    this.isDisabled = false,
    this.isWeekend = false,
    this.isHoliday = false,
    this.isWeekday = false,
    this.isNotTargeted = false,
    this.date,
  });
}

class XDatePickerController {
  final int _totalPerDate = 35;
  DateTime? selectedDate;
  DateTime? selectedDateEnd;
  DateTime? selectedTime = DateTime(0, 0, 0, 0, 0);
  late DateTime targetDate;
  int ampms = 0;
  Fresh<bool> state = Fresh(false);

  setYear(int? year, DateTime? start, DateTime? end) async {
    start ??= DateTime(1900, 1, 1);
    end ??= DateTime(2100, 1, 1);
    final yearAvailable = List.generate(((end.year) - (start.year)) + 1, (index) {
      final year = (end?.year ?? 2100) - index;
      return year;
    });
    final scrollController = ScrollController();
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: ENV.navigatorKey.currentContext!,
      builder: (context) {
        return bottom(
          scrollController: scrollController,
          full: false,
          context: context,
          title: 'Select Year',
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return ListWheelScrollView.useDelegate(
                      itemExtent: 150 / 3.2,
                      diameterRatio: 10,
                      physics: const FixedExtentScrollPhysics(),
                      controller: FixedExtentScrollController(
                        initialItem: (yearAvailable.length - 1) - (year ?? 0) % (start?.year ?? 0),
                      ),
                      onSelectedItemChanged: (index) {
                        final compare = DateTime(yearAvailable[index], targetDate.month, targetDate.day);
                        final s = DateTime(start!.year, start.month, start.day);
                        final e = DateTime(end!.year, end.month, end.day);
                        year = yearAvailable[index];
                        if (compare.isBefore(s)) {
                          targetDate = s;
                          setState(() {});
                          return;
                        } else if (compare.isAfter(e)) {
                          targetDate = e;
                          setState(() {});
                          return;
                        } else {
                          targetDate = compare;
                        }
                        setState(() {});
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          bool isSelected = yearAvailable[index] == year;
                          return Center(
                            child: Text(
                              yearAvailable[index].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected ? Colors.black : Colors.black.withValues(alpha: 0.5),
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          );
                        },
                        childCount: yearAvailable.length, // Sesuai dengan jumlah tahun yang tersedia
                      ),
                    );
                  },
                ),
              ),
              MaterialXButton(
                onTap: () {
                  Navigator.pop(context);
                },
                title: 'Select',
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );

    scrollController.dispose();

    state.refresh((listener) => null);
  }

  getThisMonth() {
    const month = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return month[targetDate.month - 1];
  }

  _checkLimit(target, DateTime? limitStart, DateTime? limitEnd) {
    if (limitStart != null) {
      if (target.isBefore(limitStart)) {
        return false;
      }
    }

    if (limitEnd != null) {
      if (target.isAfter(limitEnd.subtract(Duration(days: 1)))) {
        return false;
      }
    }
    return true;
  }

  subMonth(DateTime? limit) {
    if (_checkLimit(targetDate, limit, null)) {
      targetDate = DateTime(targetDate.year, targetDate.month - 1, targetDate.day);
      state.refresh((listener) => null);
    }
  }

  addMonth(DateTime? limit) {
    if (_checkLimit(targetDate, null, limit)) {
      targetDate = DateTime(targetDate.year, targetDate.month + 1, targetDate.day);
      state.refresh((listener) => null);
    }
  }

  isSelected(DateTime? date) {
    return selectedDate == date || selectedDateEnd == date;
  }

  getThisYear() {
    return targetDate.year;
  }

  dayNameToCounter(String dayName) {
    return ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'].indexOf(dayName);
  }

  selectTime(int? hour, int? minute, int? ampm) {
    DateTime time = DateTime(0, 0, 0, 0, 0);
    if (ampm != null) {
      ampms = ampm;
      time = DateTime(0, 0, 0, ((selectedTime?.hour ?? 0) % 12) + (ampm == 0 ? 0 : 12), selectedTime?.minute ?? 0);
    }

    if (minute != null) {
      if (ampms == 0) {
        time = DateTime(0, 0, 0, (selectedTime?.hour ?? 0), minute);
      } else {
        time = DateTime(0, 0, 0, (selectedTime?.hour ?? 0) + 12, minute);
      }
    }

    if (hour != null) {
      if (ampms == 0) {
        time = DateTime(0, 0, 0, hour, selectedTime?.minute ?? 0);
      } else {
        time = DateTime(0, 0, 0, hour + 12, selectedTime?.minute ?? 0);
      }
    }
    selectedTime = time;
    state.refresh((listener) => null);
  }

  selectDate(DateTime? date, {bool isRanged = false}) {
    if (selectedDate == date || selectedDateEnd == date || (selectedDate != null && selectedDateEnd != null)) {
      selectedDate = null;
      selectedDateEnd = null;
    } else if (isRanged && selectedDate != null) {
      selectedDateEnd = date;
    } else {
      selectedDate = date;
    }
    state.refresh((listener) => null);
  }

  List<CellDate> targetedDay() {
    List<CellDate> dayList = [];
    DateTime firstDayThisMonth = DateTime(targetDate.year, targetDate.month, 1);
    DateTime lastDayThisMonth = DateTime(targetDate.year, targetDate.month + 1, 0);
    String dayName = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'][firstDayThisMonth.weekday % 7];
    if (dayName == 'Su') {
      dayList = List.generate(
        lastDayThisMonth.day,
        (index) => CellDate(day: (index + 1).toString(), date: DateTime(targetDate.year, targetDate.month, index + 1)),
      );
    } else {
      DateTime lastDayPreviousMonth = DateTime(targetDate.year, targetDate.month, 0);
      String dayNamePrevious = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'][lastDayPreviousMonth.weekday % 7];
      int dayNamePreviousCounter = dayNameToCounter(dayNamePrevious) + 1;
      for (int i = (lastDayPreviousMonth.day - dayNamePreviousCounter); i < lastDayPreviousMonth.day; i++) {
        dayList.add(
          CellDate(
            day: (i + 1).toString(),
            isNotTargeted: true,
            date: DateTime(targetDate.year, targetDate.month - 1, i + 1),
          ),
        );
      }

      dayList.insertAll(
        dayNamePreviousCounter,
        List.generate(
          lastDayThisMonth.day,
          (index) =>
              CellDate(day: (index + 1).toString(), date: DateTime(targetDate.year, targetDate.month, index + 1)),
        ),
      );
    }

    if (dayList.length < _totalPerDate) {
      final totals = (_totalPerDate) - (dayList.length);
      for (int i = 0; i < totals; i++) {
        dayList.add(
          CellDate(
            day: (i + 1).toString(),
            isNotTargeted: true,
            date: DateTime(targetDate.year, targetDate.month + 1, i + 1),
          ),
        );
      }
    }
    return dayList;
  }

  dispose() {
    state.dispose();
  }

  XDatePickerController({DateTime? targetDate, DateTime? rangeDate}) {
    if (targetDate != null) {
      selectedDate = DateTime(targetDate.year, targetDate.month, targetDate.day);
      selectedTime = DateTime(0, 0, 0, targetDate.hour, targetDate.minute);
      if (selectedTime!.hour > 12) {
        ampms = 1;
      } else {
        ampms = 0;
      }
    }

    if (rangeDate != null) {
      selectedDateEnd = DateTime(rangeDate.year, rangeDate.month, rangeDate.day);
    }

    this.targetDate = targetDate ?? DateTime.now().pst();
  }
}

class XDatePicker extends StatelessWidget {
  final XDatePickerController controller;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? withTime, timeOnly;
  final bool? withRange;
  final bool? isEnable;
  final String? timeTitle;
  final Function(DateTime?)? onSelect;
  const XDatePicker({
    super.key,
    required this.controller,
    this.startDate,
    this.endDate,
    this.withTime = false,
    this.withRange = false,
    this.isEnable = true,
    this.timeTitle,
    this.timeOnly = false,
    this.onSelect,
  });

  textStyleSelectedPrimary() {
    return const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600);
  }

  textStyleSelectedSecond() {
    return TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600);
  }

  @override
  Widget build(BuildContext context) {
    const List<String> dayString = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size parentSize = Size(constraints.maxWidth, constraints.maxHeight);
        const int limitPerRow = 7;
        final int widthPerCell = parentSize.width ~/ limitPerRow;
        final dynamicPaddingPerCell = (parentSize.width - (widthPerCell * limitPerRow)) / 2;
        return Fresher<bool>(
          listener: controller.state,
          builder: (_, state) {
            final targeted = controller.targetedDay();
            return Column(
              children: [
                timeOnly == true
                    ? SizedBox()
                    : Builder(
                        builder: (context) {
                          final thisMonth = controller.getThisMonth();
                          final thisYear = controller.getThisYear();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black.withValues(alpha: 0.19)),
                              ),
                              child: Row(
                                children: [
                                  NoSplashButton(
                                    onTap: () {
                                      controller.subMonth(startDate);
                                    },
                                    child: Icon(
                                      (Icons.chevron_left),
                                      color: Colors.black.withValues(alpha: 0.5),
                                      size: 30,
                                    ),
                                  ),
                                  const Spacer(),
                                  RichText(
                                    text: TextSpan(
                                      text: thisMonth.toUpperCase(),
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: ' $thisYear',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              controller.setYear(controller.targetDate.year, startDate, endDate);
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  NoSplashButton(
                                    onTap: () {
                                      controller.addMonth(endDate);
                                    },
                                    child: Icon(
                                      (Icons.chevron_right),
                                      color: Colors.black.withValues(alpha: 0.5),
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                timeOnly == true
                    ? SizedBox()
                    : Container(
                        padding: const EdgeInsets.only(bottom: 24),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          border: timeOnly == true || withTime == false
                              ? null
                              : Border(bottom: BorderSide(color: Colors.black.withValues(alpha: 0.1))),
                        ),
                        child: Stack(
                          children: [
                            withRange == true
                                ? Positioned(
                                    top: 0,
                                    left: 0,
                                    bottom: 0,
                                    right: 0,
                                    child: Column(
                                      children: [
                                        SizedBox(height: widthPerCell.toDouble()),
                                        Builder(
                                          builder: (context) {
                                            const int perRow = 5;
                                            const int perCell = 7;
                                            return Column(
                                              children: List.generate(perRow, (index) {
                                                return Row(
                                                  children: List.generate(
                                                    perCell,
                                                    (index2) => Builder(
                                                      builder: (context) {
                                                        int indexCurrent = (index * perCell) + index2;
                                                        bool isIndexStart =
                                                            targeted[indexCurrent].date == controller.selectedDate;
                                                        bool isIndexEnd = false;
                                                        bool isBridge = false;
                                                        if (controller.selectedDateEnd != null &&
                                                            controller.selectedDate != null) {
                                                          if (!isIndexStart) {
                                                            isIndexEnd =
                                                                targeted[indexCurrent].date ==
                                                                controller.selectedDateEnd;
                                                          }

                                                          if (!isIndexStart && !isIndexEnd) {
                                                            isBridge =
                                                                (targeted[indexCurrent].date?.isAfter(
                                                                      controller.selectedDate!,
                                                                    ) ??
                                                                    false) &&
                                                                (targeted[indexCurrent].date?.isBefore(
                                                                      controller.selectedDateEnd!,
                                                                    ) ??
                                                                    false);
                                                          }
                                                        }

                                                        return SizedBox(
                                                          width: widthPerCell.toDouble(),
                                                          height: widthPerCell.toDouble(),
                                                          child: Center(
                                                            child: Container(
                                                              margin: EdgeInsets.zero,
                                                              padding: EdgeInsets.zero,
                                                              decoration: BoxDecoration(
                                                                color: isIndexStart || isIndexEnd || isBridge
                                                                    ? Colors.black.withValues(alpha: 0.5)
                                                                    : Colors.transparent,
                                                                border: Border.all(color: Colors.transparent),
                                                                borderRadius: index2 == 0 || isIndexStart
                                                                    ? const BorderRadius.only(
                                                                        topLeft: Radius.circular(100),
                                                                        bottomLeft: Radius.circular(100),
                                                                      )
                                                                    : index2 == perCell - 1 || isIndexEnd
                                                                    ? const BorderRadius.only(
                                                                        topRight: Radius.circular(100),
                                                                        bottomRight: Radius.circular(100),
                                                                      )
                                                                    : null,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              }),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            Wrap(
                              children: [
                                for (int i = 0; i < 7; i++)
                                  SizedBox(
                                    width: widthPerCell.toDouble(),
                                    height: widthPerCell.toDouble(),
                                    child: Center(
                                      child: Text(
                                        dayString[i],
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                for (int i = 0; i < 7 * 5; i++)
                                  Builder(
                                    builder: (context) {
                                      String? data;
                                      try {
                                        data = targeted[i].day;
                                      } catch (e) {
                                        data = '-';
                                      }
                                      final isDisabled = targeted[i].date == null
                                          ? false
                                          : (DateTime.now().pst().isAfter(targeted[i].date!)) && withRange == true
                                          ? true
                                          : startDate != null
                                          ? DateTime(
                                              startDate!.year,
                                              startDate!.month,
                                              startDate!.day,
                                            ).isAfter(targeted[i].date!)
                                          : false;
                                      final isDisabledEnd = endDate != null
                                          ? DateTime(
                                              endDate!.year,
                                              endDate!.month,
                                              endDate!.day,
                                            ).isBefore(targeted[i].date!)
                                          : false;

                                      bool isBridge = false;
                                      if (controller.selectedDate != null && controller.selectedDateEnd != null) {
                                        isBridge =
                                            (targeted[i].date?.isAfter(controller.selectedDate!) ?? false) &&
                                            (targeted[i].date?.isBefore(controller.selectedDateEnd!) ?? false);
                                      }
                                      return Container(
                                        padding: EdgeInsets.symmetric(horizontal: dynamicPaddingPerCell),
                                        width: widthPerCell.toDouble(),
                                        height: widthPerCell.toDouble(),
                                        child: NoSplashButton(
                                          onTap: isEnable == false || isDisabled || isDisabledEnd
                                              ? null
                                              : () {
                                                  controller.state.refresh((listener) {
                                                    controller.selectDate(
                                                      targeted[i].date,
                                                      isRanged: withRange ?? false,
                                                    );
                                                    if (onSelect != null) {
                                                      onSelect!(targeted[i].date);
                                                    }
                                                  });
                                                },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  controller.isSelected(targeted[i].date) &&
                                                      controller.selectedDate != null
                                                  ? Color(0xff3DBC81)
                                                  : Colors.transparent,
                                            ),
                                            child: Center(
                                              child: Text(
                                                data,
                                                style: isBridge
                                                    ? textStyleSelectedSecond()
                                                    : controller.isSelected(targeted[i].date) &&
                                                          controller.selectedDate != null
                                                    ? textStyleSelectedPrimary()
                                                    : TextStyle(
                                                        color: targeted[i].isNotTargeted || isDisabled || isDisabledEnd
                                                            ? Colors.black.withValues(alpha: 0.3)
                                                            : Colors.black,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                withTime == true
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Center(),
                          timeTitle == null
                              ? const SizedBox()
                              : SizedBox(
                                  width: parentSize.width,
                                  child: Text(
                                    timeTitle ?? '',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                  ),
                                ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(width: parentSize.width),
                              SizedBox(
                                height: 150, // Berikan tinggi tetap
                                width: parentSize.width * 0.8,
                                child: Row(
                                  children: [
                                    // Jam
                                    Expanded(
                                      child: ListWheelScrollView.useDelegate(
                                        itemExtent: 150 / 3.2,
                                        diameterRatio: 10,
                                        physics: const FixedExtentScrollPhysics(),
                                        controller: FixedExtentScrollController(
                                          initialItem: (controller.selectedTime?.hour ?? 0) % 12,
                                        ),
                                        onSelectedItemChanged: (index) {
                                          controller.selectTime(index % 12, null, null);
                                        },
                                        childDelegate: ListWheelChildBuilderDelegate(
                                          builder: (context, index) {
                                            bool isSelected = (controller.selectedTime?.hour ?? 0) % 12 == (index % 12);
                                            return Center(
                                              child: Text(
                                                ((index % 12) == 0 ? '12' : (index % 12).toString()).toString().padLeft(
                                                  2,
                                                  '0',
                                                ),
                                                style: TextStyle(
                                                  fontSize: isSelected ? 16 : 14,
                                                  color: isSelected
                                                      ? Colors.black
                                                      : Colors.black.withValues(alpha: 0.5),
                                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                                ),
                                              ),
                                            );
                                          },
                                          childCount: null, // Unlimited scroll
                                        ),
                                      ),
                                    ),
                                    const Text(':', style: TextStyle(fontSize: 24)),
                                    // Menit
                                    Expanded(
                                      child: ListWheelScrollView.useDelegate(
                                        itemExtent: 150 / 3.2,
                                        diameterRatio: 10,
                                        physics: const FixedExtentScrollPhysics(),
                                        controller: FixedExtentScrollController(
                                          initialItem: ((controller.selectedTime?.minute ?? 0) / 30).floor(),
                                        ),
                                        onSelectedItemChanged: (index) {
                                          // Handle minute selection
                                          controller.selectTime(null, index * 30, null);
                                        },
                                        childDelegate: ListWheelChildBuilderDelegate(
                                          builder: (context, index) {
                                            bool isSelected = (controller.selectedTime?.minute ?? 0) / 30 == index;
                                            return Center(
                                              child: Text(
                                                index % 2 == 0 ? '00' : '30',
                                                style: TextStyle(
                                                  fontSize: isSelected ? 16 : 14,
                                                  color: isSelected
                                                      ? Colors.black
                                                      : Colors.black.withValues(alpha: 0.5),
                                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                                ),
                                              ),
                                            );
                                          },
                                          childCount: 2, // Hanya 2 item
                                        ),
                                        // Mengatur agar hanya 3 item yang terlihat
                                      ),
                                    ),
                                    // AM/PM
                                    Expanded(
                                      child: ListWheelScrollView.useDelegate(
                                        itemExtent: 50,
                                        diameterRatio: 1.5,
                                        physics: const FixedExtentScrollPhysics(),
                                        onSelectedItemChanged: (index) {
                                          controller.selectTime(null, null, index);
                                          // Handle AM/PM selection
                                        },
                                        controller: FixedExtentScrollController(initialItem: controller.ampms),
                                        childDelegate: ListWheelChildBuilderDelegate(
                                          builder: (context, index) {
                                            bool isSelected = (controller.ampms) % 2 == index;
                                            return Center(
                                              child: Text(
                                                index % 2 == 0 ? 'AM' : 'PM',
                                                style: TextStyle(
                                                  fontSize: isSelected ? 16 : 14,
                                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                                  color: isSelected
                                                      ? Colors.black
                                                      : Colors.black.withValues(alpha: 0.5),
                                                ),
                                              ),
                                            );
                                          },
                                          childCount: 2, // Unlimited scroll
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: IgnorePointer(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              top: BorderSide(color: Color(0xff8B8B8B)),
                                              bottom: BorderSide(color: Color(0xff8B8B8B)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        );
      },
    );
  }
}
