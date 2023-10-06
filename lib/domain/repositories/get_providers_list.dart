import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';

abstract interface class ProvidersRepository {
  Map<String, BaseProvider> getProviderList(String mediaType);

  Future<void> saveDefaultProvider(BaseProvider provider, String directeory,
      [void Function()? callback]);

  Future<BaseProvider?> getDefaultProvider(
    ProviderType type,
    String directeory,
  );
}
