import 'dart:async';

import 'package:build/build.dart' hide log;
import 'package:intl_utils/intl_utils.dart';

class IntlGenerator implements Builder {
  IntlGenerator(this.options) {
    print('IntlGenerator running');
    () async {
      var generator = Generator();
      await generator.generateAsync();
    }();
  }

  BuilderOptions options;

  @override
  Future<void> build(BuildStep buildStep) async {}

  @override
  Map<String, List<String>> get buildExtensions => {
        '{{}}.arb': ['{{}}.dart']
      };
}
