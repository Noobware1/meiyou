import 'package:meiyou/core/resources/providers/base_provider.dart';

abstract interface class GetProviderListRepository {
  Map<String, BaseProvider> getProviderList(String mediaType);
}
