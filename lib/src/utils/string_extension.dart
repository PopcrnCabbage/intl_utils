import 'dart:math';

extension StringExtension on String {
  String capitalizeFirst() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String lowerCaseFirst() {
    return '${this[0].toLowerCase()}${substring(1)}';
  }

  String toCamelCase() {
    final s = replaceAllMapped(
            RegExp(
                r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
            (Match m) =>
                '${m[0]![0].toUpperCase()}${m[0]!.substring(1).toLowerCase()}')
        .replaceAll(RegExp(r'(_|-|\s)+'), '');
    return s[0].toLowerCase() + s.substring(1);
  }
}
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();


String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
