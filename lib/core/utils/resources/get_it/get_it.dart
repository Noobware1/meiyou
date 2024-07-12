import 'dart:async';

import 'package:get_it/get_it.dart';

late final GetIt getIt;

extension GetItExtensions on GetIt {
  FutureOr unregisterIfRegistered<T extends Object>({
    Object? instance,
    String? instanceName,
    FutureOr Function(T)? disposingFunction,
  }) {
    if (isRegistered<T>(
      instance: instance,
      instanceName: instanceName,
    )) {
      return unregister<T>();
    }
  }
}

abstract class GetItModule {
  void register();
}
