import 'package:flutter/widgets.dart';

enum FormStatus { success, error, nothing }

enum Validation { email, nothing }

var regexEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

class MaterialXFormController {
  bool isRequired, onlySuccessParameter;
  late TextEditingController controller;
  FormStatus status;
  FocusNode? focusNode;
  bool isFocused = false;
  Widget? suffix, prefix;
  Validation validation = Validation.nothing;

  String get text => controller.text;

  dispose() {
    try {
      controller.dispose();
    } catch (_) {}
  }

  MaterialXFormController changeSuffix(suffixs, [disableAll = false]) {
    if (disableAll) {
      prefix = null;
    }
    suffix = suffixs;
    return this;
  }

  MaterialXFormController changePrefix(prefixs, [disableAll = false]) {
    if (disableAll) {
      suffix = null;
    }
    prefix = prefixs;
    return this;
  }

  MaterialXFormController({
    String? text,
    this.isRequired = false,
    this.onlySuccessParameter = false,
    this.status = FormStatus.nothing,
    this.isFocused = false,
    this.validation = Validation.nothing,
  }) {
    controller = TextEditingController();
    if (text != null) {
      controller.text = text;
    }
  }
}
