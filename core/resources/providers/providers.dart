import 'package:meiyou/core/resources/providers/base_provider.dart';

abstract class Providers {
  Map<String, BaseProvider> get providers;

  T get<T>(String name) => providers[name] as T;

  
}


