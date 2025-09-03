import 'package:dot_test/controllers/main_controller.dart';
import 'package:dot_test/material/form/materialxformcontroller.dart';
import 'package:dot_test/material/fresher/fresher.dart';
import 'package:dot_test/material/helper/currency.dart';
import 'package:flutter/material.dart';

class MaterialXForm extends StatelessWidget {
  final bool flat;
  final double scaled;
  final MaterialXFormController? controller;
  final String? title, subtitle, hintText;
  final Function? onPressEnter;
  final bool centerTextField;
  final bool isEnabled;
  final bool escapeFormating;
  final bool disableFocus;
  final Function? onTap;
  final int? maxLines, maxLength;
  final Widget? group, errorWidget;
  final bool isNumber, isCurrency, obsecure, isPhone, countingActive;
  final Widget? customChild;
  final Color? textColor;
  final bool autoRefresh;
  final Function(String)? onChanged;

  const MaterialXForm({
    super.key,
    required this.controller,
    this.title,
    this.hintText = '',
    this.textColor,
    this.onPressEnter,
    this.centerTextField = false,
    this.isEnabled = true,
    this.onTap,
    this.onChanged,
    this.maxLines = 1,
    this.group,
    this.isNumber = false,
    this.escapeFormating = false,
    this.isCurrency = false,
    this.isPhone = false,
    this.obsecure = false,
    this.customChild,
    this.maxLength,
    this.scaled = 1.0,
    this.flat = false,
    this.errorWidget,
    this.disableFocus = false,
    this.subtitle,
    this.countingActive = false,
    this.autoRefresh = true,
  });

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return SizedBox();
    }
    return Fresher<bool>(
      listener: MainController.state.fresher,
      builder: (v, state) {
        print('state');
        return GestureDetector(
          onTap: () async {
            if (!isEnabled) {
              if (onTap != null) {
                await onTap!();
              }
            } else {
              controller!.focusNode?.requestFocus();
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: flat || title == null ? EdgeInsets.zero : const EdgeInsets.only(bottom: 6.0),
                child: title == null
                    ? const SizedBox()
                    : Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$title',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: controller!.isRequired ? ' *' : '',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 14 * scaled, fontWeight: FontWeight.w500),
                      ),
              ),
              subtitle != null && !flat
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: subtitle == null
                          ? const SizedBox()
                          : Text(
                              subtitle ?? '',
                              style: TextStyle(
                                fontSize: 12 * scaled,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff726C6C),
                              ),
                            ),
                    )
                  : const SizedBox(),

              Opacity(
                opacity: !isEnabled && onTap == null ? 0.6 : 1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: SingleChildScrollView(
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Fresher<bool>(
                              listener: MainController.state.fresher,
                              builder: (isFocused, s) {
                                try {
                                  return Container(
                                    padding: flat
                                        ? EdgeInsets.zero
                                        : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                      border: disableFocus
                                          ? Border.all(width: 1, color: flat ? Colors.transparent : Color(0xffB5B3B3))
                                          : controller!.focusNode?.hasFocus == true
                                          ? Border.all(
                                              width: 1,
                                              color: flat ? Colors.transparent : Colors.green.withValues(alpha: 1),
                                            )
                                          : controller!.status == FormStatus.error
                                          ? Border.all(width: 1, color: flat ? Colors.transparent : Colors.red)
                                          : controller!.status == FormStatus.success
                                          ? Border.all(
                                              width: 1,
                                              color: flat ? Colors.transparent : Colors.green.withValues(alpha: 1),
                                            )
                                          : isFocused
                                          ? Border.all(width: 1, color: flat ? Colors.transparent : Color(0xffB5B3B3))
                                          : Border.all(width: 1, color: flat ? Colors.transparent : Color(0xffB5B3B3)),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        controller!.prefix ?? const SizedBox(),
                                        Expanded(
                                          child:
                                              customChild ??
                                              TextField(
                                                focusNode: controller!.focusNode,
                                                controller: controller!.controller,
                                                autocorrect: true,
                                                keyboardType: isNumber || isCurrency || isPhone
                                                    ? TextInputType.phone
                                                    : null,
                                                textAlign: centerTextField ? TextAlign.center : TextAlign.start,
                                                style: TextStyle(
                                                  color: textColor ?? Color(0xff2B2829),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14 * scaled,
                                                ),
                                                scrollPadding: EdgeInsets.zero,
                                                obscureText: obsecure,
                                                onChanged: (text) async {
                                                  if (!escapeFormating) {
                                                    // if (obsecure) {
                                                    //   if (!regexPassword.hasMatch(text)) {
                                                    //     controller!.status = FormStatus.nothing;
                                                    //   } else {
                                                    //     controller!.status = FormStatus.success;
                                                    //   }
                                                    // }

                                                    if (isNumber || isCurrency) {
                                                      // text = text.replaceAll(regex, '');
                                                      if (text == '') {
                                                        controller!.controller.text = '';
                                                      }
                                                    }
                                                    if (isCurrency) {
                                                      currencyFormat(controller: controller!.controller, data: text);
                                                    }
                                                  }

                                                  if (isPhone) {
                                                    if (text.isNotEmpty) {
                                                      String formattedText = '';
                                                      String digitsOnly = text.replaceAll(RegExp(r'\D'), '');

                                                      if (digitsOnly.length > 3) {
                                                        formattedText += '${digitsOnly.substring(0, 3)} ';
                                                        digitsOnly = digitsOnly.substring(3);
                                                      }

                                                      while (digitsOnly.isNotEmpty) {
                                                        if (digitsOnly.length > 4) {
                                                          formattedText += '${digitsOnly.substring(0, 4)} ';
                                                          digitsOnly = digitsOnly.substring(4);
                                                        } else {
                                                          formattedText += digitsOnly;
                                                          break;
                                                        }
                                                      }

                                                      controller!.controller.value = TextEditingValue(
                                                        text: formattedText.trim(),
                                                        selection: TextSelection.collapsed(
                                                          offset: formattedText.trim().length,
                                                        ),
                                                      );
                                                    }
                                                  }

                                                  // if (isPhone) {
                                                  //   if (text.isNotEmpty) {
                                                  //     String formattedText = '';
                                                  //     String digitsOnly = text.replaceAll(RegExp(r'\D'), '');

                                                  //     // Format (xxx) xxx-xxxx
                                                  //     if (digitsOnly.length > 10) {
                                                  //       digitsOnly = digitsOnly.substring(0, 10);
                                                  //     }

                                                  //     if (digitsOnly.length > 3) {
                                                  //       formattedText += '(${digitsOnly.substring(0, 3)}) ';
                                                  //       digitsOnly = digitsOnly.substring(3);

                                                  //       if (digitsOnly.length > 3) {
                                                  //         formattedText += '${digitsOnly.substring(0, 3)}-';
                                                  //         digitsOnly = digitsOnly.substring(3);
                                                  //       }

                                                  //       formattedText += digitsOnly;
                                                  //     } else {
                                                  //       formattedText = '($digitsOnly';
                                                  //     }

                                                  //     controller.controller!.value = TextEditingValue(
                                                  //       text: formattedText.trim(),
                                                  //       selection: TextSelection.collapsed(offset: formattedText.trim().length),
                                                  //     );
                                                  //   }
                                                  // }

                                                  if (controller!.validation == Validation.email) {
                                                    if (regexEmail.hasMatch(controller!.controller.text)) {
                                                      controller!.status = FormStatus.nothing;

                                                      if (autoRefresh) {
                                                        state(() {});
                                                      }
                                                    } else {
                                                      controller!.status = FormStatus.nothing;

                                                      if (autoRefresh) {
                                                        state(() {});
                                                      }
                                                    }
                                                  } else if (text.isEmpty && controller!.isRequired) {
                                                    controller!.status = FormStatus.error;

                                                    if (autoRefresh) {
                                                      state(() {});
                                                    }
                                                  } else if (text.isNotEmpty && controller!.isRequired) {
                                                    controller!.status = FormStatus.nothing;

                                                    if (autoRefresh) {
                                                      state(() {});
                                                    }
                                                  } else if (text.isNotEmpty && controller!.onlySuccessParameter) {
                                                    controller!.status = FormStatus.nothing;

                                                    if (autoRefresh) {
                                                      state(() {});
                                                    }
                                                  } else {
                                                    controller!.status = FormStatus.nothing;

                                                    if (autoRefresh) {
                                                      state(() {});
                                                    }
                                                  }
                                                  if (onChanged != null) {
                                                    await onChanged!(text);
                                                    if (autoRefresh) {
                                                      state(() {});
                                                    }
                                                  }
                                                },
                                                onTap: () async {
                                                  if (isCurrency || isNumber) {
                                                    if (controller!.controller.text == '0') {
                                                      controller!.controller.text = '';
                                                    }
                                                  }
                                                  if (onTap != null) {
                                                    await onTap!();
                                                  }
                                                },
                                                onEditingComplete: () {
                                                  if (onPressEnter != null) {
                                                    onPressEnter!();
                                                  }
                                                  final FocusScopeNode currentScope = FocusScope.of(context);
                                                  if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                                                    FocusManager.instance.primaryFocus!.unfocus();
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  enabled: isEnabled,
                                                  counterText: countingActive == true ? null : '',
                                                  counterStyle: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                    color: Color(0xff726C6C),
                                                  ),
                                                  contentPadding: EdgeInsets.zero,
                                                  isDense: true,
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  enabledBorder: InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder: InputBorder.none,
                                                  hintText: '$hintText',
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: textColor?.withValues(alpha: 0.45) ?? Color(0xff726C6C),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                maxLines: maxLines,
                                                maxLength: maxLength,
                                              ),
                                        ),
                                        controller!.suffix ??
                                            // (controller.status == FormStatus.success
                                            //     ? const Padding(
                                            //         padding: EdgeInsets.only(left: 8.0),
                                            //         child: Icon(
                                            //           Icons.check_circle,
                                            //           color: Colors.green,
                                            //         ),
                                            //       )
                                            //     :
                                            (controller!.status == FormStatus.error
                                                ? const SizedBox()
                                                : const SizedBox(height: 25)),
                                      ],
                                    ),
                                  );
                                } catch (_) {
                                  return SizedBox();
                                }
                              },
                            ),
                          ),
                          group ?? const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              errorWidget ?? const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
