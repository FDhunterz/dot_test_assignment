import 'dart:async';

import 'package:dot_test/material/animation/animation.dart';
import 'package:dot_test/material/api/api_helper/navigator_helper.dart';
import 'package:dot_test/material/base_widget/base_widget.dart';
import 'package:dot_test/material/button/button.dart';
import 'package:dot_test/material/button/checkbox.dart';
import 'package:dot_test/material/form/materialxform.dart';
import 'package:dot_test/material/form/materialxformcontroller.dart';

import 'package:flutter/material.dart';

SelectData? _selectedData;
MultiSelectData? _multiSelectedData;
SelectState _selectStates = SelectState();

class SelectState {
  double offset;
  BuildContext? context;

  SelectState({this.context, this.offset = 0});
}

class Select {
  static Future<SelectData?> single({
    List<SelectData>? data,
    String? selectedId,
    required title,
    required context,
    SelectStyle? style,
    bool? withSearch = false,
    bool onlySelect = false,
    double? fontSize,
    bool isFull = false,
    bool fullScreen = true,
    int? selected,
  }) async {
    style ??= SelectStyle();
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
    await Future.delayed(Duration.zero, () async {
      return showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) => SelectBase(
          fontSize: fontSize,
          withSearch: withSearch,
          data: data ?? [],
          selectedid: selectedId,
          title: title,
          style: style!,
          isFull: isFull,
          onlySelect: onlySelect,
          fullScreen: fullScreen,
        ),
      );
    });
    return _selectedData;
  }

  static Future<SelectData?> singleV2({
    List<SelectData>? data,
    String? selectedId,
    required title,
    required context,
    SelectStyle? style,
    bool? withSearch = false,
    bool onlySelect = false,
    double? fontSize,
    bool isFull = false,
    bool fullScreen = true,
    double? offset,
  }) async {
    style ??= SelectStyle();
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
    await Future.delayed(Duration.zero, () async {
      return showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          if (_selectStates.context != context) {
            _selectStates.offset = 0;
          }
          _selectStates.context = context;
          return SelectBaseV2(
            fontSize: fontSize,
            withSearch: withSearch,
            data: data ?? [],
            selectedid: selectedId,
            title: title,
            style: style!,
            offset: offset,
            isFull: isFull,
            onlySelect: onlySelect,
          );
        },
      );
    });
    return _selectedData;
  }

  static Future<List<SelectData>?> multi({
    List<SelectData>? data,
    List<String>? selectedId,
    required title,
    required context,
    SelectStyle? style,
    ScrollController? scrollController,
    bool? isSelectAll = false,
  }) async {
    style ??= SelectStyle();
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }

    scrollController ??= ScrollController();

    final d = await Future.delayed(Duration.zero, () async {
      final dd = await showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) => MultiSelectBase(
          data: data ?? [],
          selectedid: selectedId,
          title: title,
          style: style!,
          scrollController: scrollController!,
          isSelectAll: isSelectAll,
        ),
      );
      Future.delayed(const Duration(milliseconds: 600), () {
        scrollController!.dispose();
      });
      return dd;
    });

    return d as List<SelectData>?;
  }
}

class SelectBase extends StatefulWidget {
  final List<SelectData>? data;
  final String? selectedid;
  final String title;
  final SelectStyle style;
  final bool? withSearch;
  final bool onlySelect;
  final double? fontSize;
  final bool isFull;
  final bool fullScreen;
  const SelectBase({
    super.key,
    this.data,
    this.selectedid,
    required this.title,
    required this.style,
    this.withSearch = true,
    this.onlySelect = false,
    this.fontSize,
    this.isFull = false,
    this.fullScreen = true,
  });

  static getSelectedData() {
    return _selectedData;
  }

  @override
  // ignore: library_private_types_in_public_api
  _SelectBase createState() => _SelectBase();
}

class _SelectBase extends State<SelectBase> {
  final ScrollController scrollController = ScrollController();
  final _searching = MaterialXFormController().changePrefix(
    const Padding(padding: EdgeInsets.only(right: 6), child: Icon(Icons.search)),
  );

  selected(SelectData selectedData) {
    _selectedData = selectedData;
    Navigate.pop();
  }

  current(id) {
    _selectedData = null;
    if (id != null && id != '') {
      for (SelectData i in widget.data ?? []) {
        if (i.id == id) {
          _selectedData = i;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    current(widget.selectedid);
  }

  @override
  dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: true,
      bottom: false,
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: widget.isFull ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 0.9,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: widget.fullScreen ? MainAxisSize.max : MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
                    child: HeaderAnimation(title: widget.title, scrollController: scrollController),
                  ),
                  widget.withSearch!
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              child: MaterialXForm(
                                controller: _searching,
                                hintText: 'Searching...',
                                onChanged: (val) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  widget.fullScreen
                      ? Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: widget.data!
                                .where(
                                  (SelectData value) =>
                                      value.title!.toUpperCase().contains(_searching.controller!.text.toUpperCase()),
                                )
                                .length,
                            itemBuilder: (context, index) {
                              final value = widget.data!
                                  .where(
                                    (SelectData value) =>
                                        value.title!.toUpperCase().contains(_searching.controller!.text.toUpperCase()),
                                  )
                                  .elementAt(index);
                              return ListTile(
                                tileColor: widget.selectedid == value.id
                                    ? widget.style.selectedBackgroundTextColor ?? Colors.transparent
                                    : Colors.transparent,
                                leading: widget.onlySelect
                                    ? null
                                    : Container(
                                        padding: const EdgeInsets.all(2),
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: widget.selectedid == value.id!
                                                ? widget.style.selectedTextColor ?? Color(0xff3DBC81)
                                                : const Color(0xffCBD5E1),
                                            width: 1,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: widget.selectedid == value.id!
                                                ? widget.style.selectedTextColor ?? Color(0xff3DBC81)
                                                : Colors.transparent,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                title: Text(
                                  value.title!,
                                  style: TextStyle(
                                    color: widget.selectedid == value.id
                                        ? widget.style.selectedTextColor ??
                                              (theme.textTheme.bodyMedium != null
                                                  ? theme.textTheme.bodyMedium!.color
                                                  : Colors.green)
                                        : theme.textTheme.bodyMedium!.color,
                                  ),
                                ),
                                subtitle: value.subtitle != null
                                    ? Text(value.subtitle!, style: theme.textTheme.bodySmall)
                                    : null,
                                onTap: () {
                                  selected(value);
                                },
                              );
                            },
                          ),
                        )
                      : Flexible(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.data!
                                  .where(
                                    (SelectData value) =>
                                        value.title!.toUpperCase().contains(_searching.controller!.text.toUpperCase()),
                                  )
                                  .length,
                              itemBuilder: (context, index) {
                                final value = widget.data!
                                    .where(
                                      (SelectData value) => value.title!.toUpperCase().contains(
                                        _searching.controller!.text.toUpperCase(),
                                      ),
                                    )
                                    .elementAt(index);
                                return ListTile(
                                  tileColor: widget.selectedid == value.id
                                      ? widget.style.selectedBackgroundTextColor ?? Colors.transparent
                                      : Colors.transparent,
                                  leading: widget.onlySelect
                                      ? null
                                      : Container(
                                          padding: const EdgeInsets.all(2),
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: widget.selectedid == value.id!
                                                  ? widget.style.selectedTextColor ?? Color(0xff3DBC81)
                                                  : const Color(0xffCBD5E1),
                                              width: 1,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: widget.selectedid == value.id!
                                                  ? widget.style.selectedTextColor ?? Color(0xff3DBC81)
                                                  : Colors.transparent,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                  title: Text(
                                    value.title!,
                                    style: TextStyle(
                                      color: widget.selectedid == value.id
                                          ? widget.style.selectedTextColor ?? Color(0xff3DBC81)
                                          : theme.textTheme.bodyMedium!.color,
                                    ),
                                  ),
                                  subtitle: value.subtitle != null
                                      ? Text(value.subtitle!, style: TextStyle(color: Colors.grey, fontSize: 11))
                                      : null,
                                  onTap: () {
                                    selected(value);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MultiSelectBase extends StatefulWidget {
  final List<SelectData>? data;
  final List<String>? selectedid;
  final String title;
  final SelectStyle style;
  final ScrollController scrollController;
  final bool? withSearch;
  final bool? isSelectAll;
  const MultiSelectBase({
    super.key,
    this.data,
    this.selectedid,
    required this.title,
    required this.style,
    this.withSearch = true,
    required this.scrollController,
    this.isSelectAll = false,
  });

  static getSelectedData() {
    return _selectedData;
  }

  @override
  // ignore: library_private_types_in_public_api
  _MultiSelectBase createState() => _MultiSelectBase();
}

class _MultiSelectBase extends State<MultiSelectBase> {
  List<SelectData>? selectedData;
  final _searching = MaterialXFormController().changePrefix(
    const Padding(padding: EdgeInsets.only(right: 6), child: Icon(Icons.search)),
  );
  Timer? delay;

  selected(SelectData data) {
    if (!(selectedData?.contains(data) ?? false)) {
      selectedData?.add(data);
    } else {
      selectedData?.remove(data);
    }

    setState(() {});
  }

  @override
  void initState() {
    selectedData ??= [];
    selectedData?.clear();
    for (var e in widget.selectedid ?? []) {
      if (widget.data?.any((element) => element.id == e) ?? false) {
        selectedData?.add(widget.data?.where((element) => element.id == e).firstOrNull ?? SelectData());
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InitControl(
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
                    child: HeaderAnimation(title: widget.title, scrollController: widget.scrollController, fixed: true),
                  ),
                  widget.withSearch!
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              child: MaterialXForm(
                                controller: _searching,
                                hintText: 'Searching...',
                                onChanged: (val) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  if (widget.isSelectAll == true)
                    NoSplashButton(
                      onTap: () {
                        if (selectedData?.isEmpty ?? true) {
                          selectedData?.addAll(widget.data!);
                        } else {
                          selectedData?.clear();
                        }
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CheckBoX(
                                checked: selectedData?.length == widget.data!.length,
                                onChange: (d) {
                                  if (selectedData?.isNotEmpty ?? false) {
                                    selectedData?.clear();
                                  } else {
                                    selectedData?.addAll(widget.data!);
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Select All', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.data!.length,
                        itemBuilder: (context, index) {
                          var value = widget.data![index];
                          return NoSplashButton(
                            onTap: () {
                              selected(value);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CheckBoX(
                                      checked: selectedData?.contains(value) ?? false,
                                      onChange: (d) {
                                        selected(value);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        value.title ?? '',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                      if (value.subtitle != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            value.subtitle ?? '',
                                            style: TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                    child: MaterialXButton(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      title: 'Select',
                      onTap: () {
                        Navigate.pop(false, selectedData);
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectResult {
  final TextEditingController name = TextEditingController();
  String? id;
}

class SelectData<T> {
  final Map<String, dynamic>? objectData;
  final List? listData;
  final String? title;
  final String? titleBold;
  final String? id;
  final T? data;
  final String? assetImage;
  final String? subtitle;
  final double? imageSize;
  double? offset;

  SelectData apply({offset}) {
    this.offset = offset;
    return this;
  }

  T parse<T>() {
    return data as T;
  }

  SelectData({
    this.id,
    this.listData,
    this.objectData,
    this.title,
    this.data,
    this.subtitle,
    this.assetImage,
    this.titleBold,
    this.offset,
    this.imageSize,
  });
}

class SelectStyle {
  Color? backgroundColor,
      /// default Theme.of(context).textTheme.caption || Colors.green
      selectedTextColor,
      // default Colors.Transparent
      selectedBackgroundTextColor;
  SelectStyle({this.backgroundColor, this.selectedBackgroundTextColor, this.selectedTextColor});
}

class MultiSelectData {
  List<String>? title;
  List<String>? id;
  List<Map<String, dynamic>>? objectData;
  List<List>? listData;

  MultiSelectData({this.id, this.listData, this.objectData, this.title});
}

class ModelMultiSelect {
  String? id, name;
  bool? active;

  ModelMultiSelect({this.id, this.name, this.active});
}

class SelectBaseV2 extends StatefulWidget {
  final List<SelectData>? data;
  final String? selectedid;
  final String title;
  final SelectStyle style;
  final bool? withSearch;
  final bool onlySelect;
  final double? fontSize, offset;
  final bool isFull;
  const SelectBaseV2({
    super.key,
    this.data,
    this.offset,
    this.selectedid,
    required this.title,
    required this.style,
    this.withSearch = true,
    this.onlySelect = false,
    this.fontSize,
    this.isFull = false,
  });

  static getSelectedData() {
    return _selectedData;
  }

  @override
  // ignore: library_private_types_in_public_api
  _SelectBaseV2 createState() => _SelectBaseV2();
}

class _SelectBaseV2 extends State<SelectBaseV2> {
  ScrollController scroll = ScrollController();
  final _searching = MaterialXFormController().changePrefix(
    const Padding(padding: EdgeInsets.only(right: 6), child: Icon(Icons.search)),
  );

  selected(SelectData selectedData) {
    _selectedData = selectedData;
    Navigate.pop();
  }

  current(id) {
    _selectedData = null;
    if (id != null && id != '') {
      for (SelectData i in widget.data ?? []) {
        if (i.id == id) {
          _selectedData = i;
        }
      }
    }
    if (_selectedData != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        try {
          scroll.jumpTo(_selectStates.offset);
        } catch (_) {}
      });
    }
  }

  @override
  void initState() {
    super.initState();
    current(widget.selectedid);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: widget.isFull ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 0.9,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Text(
                      '${widget.title} ',
                      style: TextStyle(fontSize: widget.fontSize ?? 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  widget.withSearch!
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              child: MaterialXForm(
                                controller: _searching,
                                hintText: 'Searching...',
                                onChanged: (val) {
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        )
                      : const SizedBox(),
                  Expanded(
                    child: ListView.builder(
                      controller: ScrollController(initialScrollOffset: widget.offset ?? 0),
                      itemCount: widget.data!
                          .where(
                            (SelectData value) =>
                                value.title!.toUpperCase().contains(_searching.controller!.text.toUpperCase()),
                          )
                          .length,
                      itemBuilder: (c, i) {
                        final value = widget.data!
                            .where(
                              (SelectData value) =>
                                  value.title!.toUpperCase().contains(_searching.controller!.text.toUpperCase()),
                            )
                            .toList()[i];
                        return InkWell(
                          onTap: () => selected(value),
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  value.assetImage != null
                                      ? Padding(
                                          padding: const EdgeInsets.only(right: 12.0),
                                          child: Image.asset(
                                            value.assetImage!,
                                            height: value.imageSize ?? 40,
                                            errorBuilder: (context, error, stackTrace) {
                                              return SizedBox(height: value.imageSize ?? 40);
                                            },
                                          ),
                                        )
                                      : const SizedBox(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        value.title ?? '',
                                        style: Theme.of(context).textTheme.labelSmall?.apply(
                                          color: _selectedData?.id == value.id ? Colors.blue : null,
                                        ),
                                        maxLines: 2,
                                      ),
                                      value.subtitle == null ? const SizedBox() : Text(value.subtitle ?? ''),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
