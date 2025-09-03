import 'package:dot_test/controllers/main_controller.dart';
import 'package:dot_test/material/button/button.dart';
import 'package:dot_test/material/fresher/fresher.dart';
import 'package:flutter/material.dart';

class CheckBoX extends StatelessWidget {
  final bool checked;
  final Function(bool) onChange;
  const CheckBoX({super.key, this.checked = false, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Fresher(
      listener: MainController.state.fresher,
      builder: (v, s) {
        return NoSplashButton(
          onTap: () {
            onChange(!checked);
          },
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: checked ? Color(0xff3DBC81) : Colors.grey),
                color: checked ? Color(0xff3DBC81) : Colors.transparent,
              ),
              child: Icon(Icons.check, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
