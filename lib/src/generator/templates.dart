import '../utils/utils.dart';
import 'label.dart';

class LabelInsider {
  String name = '';
  List<Label> labels = [];
  List<LabelInsider> classes = [];

  String generateDartGetter({bool root = false}) {
    var renderedClasses = classes.map((insider) =>
        '''${insider.name.toCamelCase().capitalizeFirst()} get ${insider.name.toCamelCase()} => ${insider.name.toCamelCase().capitalizeFirst()}();''');
    if (root) {
      return '${renderedClasses.join("\n\n")}';
    }
    var className = name.toCamelCase().capitalizeFirst();
    return """
      class $className {
      $className();
      
      ${renderedClasses.join("\n\n")}

      ${labels.map((label) => label.generateDartGetter()).join("\n\n")}
      }
      """;
  }
}

String generateL10nDartFileContent(
    String className, List<Label> labels, List<String> locales,
    [bool otaEnabled = false]) {
  var insiders = <String, LabelInsider>{};
  var filteredLabels = <Label>[];
  var outsideLabels = <Label>[];
  var rootInsider = LabelInsider();
  for (var label in labels) {
    var matches = '/'.allMatches(label.name);
    if (matches.length == 1) {
      label.name = label.name.replaceAll('/', '');
      label.name = label.name.toCamelCase();
      filteredLabels.add(label);
    } else {
      ///This case happens when we ve got bigger structure
      var splittedLabel =
          label.name.split('/').where((key) => key.isNotEmpty).toList();
      var labelName = splittedLabel.removeLast();
      label.name = labelName.toCamelCase();
      outsideLabels.add(label);
      var previousInsider = rootInsider;
      for (var i = 0, l = splittedLabel.length; i < l; i++) {
        var key = splittedLabel[i];
        if (!insiders.containsKey(key)) {
          insiders[key] = LabelInsider()..name = key;
        }
        var insider = insiders[key]!;
        if (i == l - 1) {
          insider.labels.add(label);
        }
        previousInsider.classes.add(insider);
        previousInsider = insider;
      }
    }
  }
  return """
// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';${otaEnabled ? '\n${_generateLocalizelySdkImport()}' : ''}
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class $className {
  $className();

  static $className? _current;

  static $className get current {
    assert(_current != null, 'No instance of $className was loaded. Try to initialize the $className delegate before accessing $className.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<$className> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);${otaEnabled ? '\n${_generateMetadataSetter()}' : ''} 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = $className();
      $className._current = instance;
 
      return instance;
    });
  } 

  static $className of(BuildContext context) {
    final instance = $className.maybeOf(context);
    assert(instance != null, 'No instance of $className present in the widget tree. Did you add $className.delegate in localizationsDelegates?');
    return instance!;
  }

  static $className? maybeOf(BuildContext context) {
    return Localizations.of<$className>(context, $className);
  }
${otaEnabled ? '\n${_generateMetadata(filteredLabels + outsideLabels)}\n' : ''}
${filteredLabels.map((label) => label.generateDartGetter()).join("\n\n")}
${rootInsider.generateDartGetter(root: true)}
}

${insiders.values.map((insider) => insider.generateDartGetter()).join("\n\n")}

class AppLocalizationDelegate extends LocalizationsDelegate<$className> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
${locales.map((locale) => _generateLocale(locale)).join("\n")}
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<$className> load(Locale locale) => $className.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
"""
      .trim();
}

String _generateLocale(String locale) {
  var parts = locale.split('_');

  if (isLangScriptCountryLocale(locale)) {
    return '      Locale.fromSubtags(languageCode: \'${parts[0]}\', scriptCode: \'${parts[1]}\', countryCode: \'${parts[2]}\'),';
  } else if (isLangScriptLocale(locale)) {
    return '      Locale.fromSubtags(languageCode: \'${parts[0]}\', scriptCode: \'${parts[1]}\'),';
  } else if (isLangCountryLocale(locale)) {
    return '      Locale.fromSubtags(languageCode: \'${parts[0]}\', countryCode: \'${parts[1]}\'),';
  } else {
    return '      Locale.fromSubtags(languageCode: \'${parts[0]}\'),';
  }
}

String _generateLocalizelySdkImport() {
  return "import 'package:localizely_sdk/localizely_sdk.dart';";
}

String _generateMetadataSetter() {
  return [
    '    if (!Localizely.hasMetadata()) {',
    '      Localizely.setMetadata(_metadata);',
    '    }'
  ].join('\n');
}

String _generateMetadata(List<Label> labels) {
  return [
    '  static final Map<String, List<String>> _metadata = {',
    labels.map((label) => label.generateMetadata()).join(',\n'),
    '  };'
  ].join('\n');
}
