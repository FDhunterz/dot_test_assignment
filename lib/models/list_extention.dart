extension ListExtention on List {
  List<Map<String, dynamic>> toListMap() {
    final List<Map<String, dynamic>> parsed = [];
    for (var i in this) {
      try {
        final json = i.toJson();
        if (json is Map<String, dynamic>) {
          parsed.add(json);
        }
      } catch (_) {}
    }
    return parsed;
  }
}
