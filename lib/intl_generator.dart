import 'package:build/build.dart';

import 'intl_adapter_generator.dart';

//intl_generator
Builder getBuilder(BuilderOptions options) => IntlGenerator(options);
