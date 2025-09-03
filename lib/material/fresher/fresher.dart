import 'package:dot_test/material/fresher/fresh.dart';
import 'package:flutter/material.dart';

class Fresher<T> extends StatelessWidget {
  final Fresh<T> listener;
  final Function(T value, void Function(void Function()) state) builder;
  const Fresher({super.key, required this.listener, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: listener.listener,
      builder: (_, v, __) {
        return StatefulBuilder(
          builder: (context, setState) {
            return builder(v, setState);
          },
        );
      },
    );
  }
}
