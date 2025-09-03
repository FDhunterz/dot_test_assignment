import 'package:flutter/material.dart';

class OutcomeType {
  String? name;
  String? assetIcon;
  Color? colorhex;

  // Widget get icon => ImageIcon(AssetImage(assetIcon ?? ''), color: colorhex);
  Widget get iconOutline => ImageIcon(AssetImage(assetIcon ?? ''), color: colorhex, size: 18);
  Widget get iconOutlineWhite => ImageIcon(AssetImage(assetIcon ?? ''), color: Colors.white, size: 18);

  Map<String, dynamic> toJson() {
    return {'name': name ?? '', 'assetIcon': assetIcon ?? '', 'colorhex': colorhex?.toARGB32()};
  }

  static OutcomeType fromJson(data) {
    final hex = data['colorhex'];
    final Color? col = hex == null ? null : (hex is int ? Color(hex) : Color(int.parse(hex, radix: 16)));
    return OutcomeType(assetIcon: data['assetIcon'], name: data['name'], colorhex: col);
  }

  OutcomeType({this.assetIcon, this.name, this.colorhex});
}
