import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:dot_test/controllers/main_controller.dart';

class ColorApps {
  static final List<Color> _bgColor = [Color(0xFF3A3C97), Color(0xFF5F64C2)];
  static final List<Color> _bgColorPrimary = [Color(0xFFFFFFFF), Color(0xFF30323C)];
  static final List<Color> _widgetBgColorPrimary = [Color(0xFFF5F5F5), Color(0xFF636262)];
  static final List<Color> _primary = [Color(0xFF000000), Color(0xFF000000)];
  static final List<Color> _secondary = [Color(0xFFE26A45), Color(0xFFE26A45)];
  static final List<Color> _white = [Color(0xFFFFFFFF), Color(0xFFFFFFFF)];
  static final List<Color> _error = [Color(0xFFDF0430), Color(0xFFDF0430)];
  static final List<Color> _formBorder = [Color(0xFFE0E0E0), Color(0xFFE0E0E0)];
  static final List<Color> _textPrimary = [Color(0xFF3A3A3A), Color(0xFFFFFFFF)];
  static final List<Color> _textSubColor = [Color(0xFF3A3A3A), Color.fromARGB(255, 193, 193, 193)];
  static final List<Color> _textSubColor3 = [Color(0xFF999999), Color.fromARGB(255, 210, 210, 210)];
  static final List<Color> _textButtonReverse = [Color(0xFFFFFFFF), Color(0xFFFFFFFF)];
  static final List<Color> _cardColor = [Color(0xffFFFFFF), Color(0xff3A3A3A)];
  static final List<Color> _info = [Color(0xFF4A89FF), Color(0xFF4A89FF)];
  static final List<Color> _warning = [Color(0xFFF44336), Color(0xFFDB9D0C)];
  static final List<Color> _bottomNav = [Color(0xFF2F3263), Color(0xFFE26A45)];
  static final List<Color> _bottomNavReverse = [Color(0xFFE26A45), Color(0xFF2F3263)];
  static final List<Color> _success = [Color(0xFF008000), Color(0xFF008000)];

  static final List<Color> _bottomNav2 = [Color(0xffFFFFFF), Color(0xFFE26A45)];

  static Color get bgColor => _bgColor[MainController.state.themeMode.index - 1];
  static Color get bgColorPrimary => _bgColorPrimary[MainController.state.themeMode.index - 1];
  static Color get widgetBgColorPrimary => _widgetBgColorPrimary[MainController.state.themeMode.index - 1];
  static Color get primary => _primary[MainController.state.themeMode.index - 1];
  static Color get secondary => _secondary[MainController.state.themeMode.index - 1];
  static Color get white => _white[MainController.state.themeMode.index - 1];
  static Color get error => _error[MainController.state.themeMode.index - 1];
  static Color get formBorder => _formBorder[MainController.state.themeMode.index - 1];
  static Color get textSubColor => _textSubColor[MainController.state.themeMode.index - 1];
  static Color get textPrimary => _textPrimary[MainController.state.themeMode.index - 1];
  static Color get textSubColor3 => _textSubColor3[MainController.state.themeMode.index - 1];
  static Color get textButtonReverse => _textButtonReverse[MainController.state.themeMode.index - 1];
  static Color get cardColor => _cardColor[MainController.state.themeMode.index - 1];
  static Color get info => _info[MainController.state.themeMode.index - 1];
  static Color get warning => _warning[MainController.state.themeMode.index - 1];
  static Color get bottomNav => _bottomNav[MainController.state.themeMode.index - 1];
  static Color get bottomNavReverse => _bottomNavReverse[MainController.state.themeMode.index - 1];
  static Color get orange => Color(0xFFE26A45);
  static Color get success => _success[MainController.state.themeMode.index - 1];
  static Color get bottomNav2 => _bottomNav2[MainController.state.themeMode.index - 1];
}
