import 'package:meiyou/core/resources/provider_type.dart';

abstract class BaseProvider {
  String get name;

  ProviderType get providerType;

  String encode(String url) =>
      Uri.encodeQueryComponent(url).replaceAll('+', '%20');



}
