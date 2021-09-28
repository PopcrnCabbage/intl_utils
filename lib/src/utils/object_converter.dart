Map<String, dynamic> parseTree(map, [delimetr = '/', removeFirst = false]) {
  var newObj = <String, dynamic>{};
  void internal(String outerKey, Map data) {
    data.forEach((key, value) {
      if (value is! Map) {
        newObj.addEntries([MapEntry('$outerKey$delimetr$key', value)]);
      } else {
        internal('$outerKey$delimetr$key', value);
      }
    });
  }

  internal('', map);
  if (removeFirst) {
    var list = newObj.entries.toList();
    for (MapEntry entry in list) {
      newObj[entry.key.toString().replaceFirst(delimetr, '')] = entry.value;
      newObj.remove(entry.key);
    }
  }
  return newObj;
}

bool isTree(Map map) {
  for (var i in map.values) {
    if (i is Map) return true;
  }
  return false;
}

parseList(Map map) {
  Map newObj = {};
  map.forEach((key, value) {
    List<String> keys = key.split('/');
    keys = keys.sublist(1);
    var currentObj = newObj;
    while (keys.length > 1) {
      if (!currentObj.containsKey(keys.first)) currentObj[keys.first] = {};
      currentObj = currentObj[keys.first];
      keys.removeAt(0);
    }
    currentObj[keys.first] = value;
  });
  return newObj;
}
