import 'package:injecktor/injecktor.dart';
import 'package:meiyou/core/utils/resources/modules/injecktor_module.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';

class ProvidersModule extends InjecktorModule {
  @override
  void inject() {
    InjectKtor.addLazySingleton(() => SelectedSource(InjectKtor.get(), InjectKtor.get()));
  }
}
