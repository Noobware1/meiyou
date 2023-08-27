import 'package:meiyou/core/resources/providers/base_provider.dart';

abstract interface class ProviderListRepository {
  Map<String, BaseProvider> getProviderList(String mediaType);
}
