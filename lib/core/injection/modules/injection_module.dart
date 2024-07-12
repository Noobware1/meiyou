import 'dart:async';

import 'package:get_it/get_it.dart';

abstract class InjectModule {
  FutureOr<void> call(GetIt getIt);
}
