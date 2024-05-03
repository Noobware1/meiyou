import 'package:injecktor/injecktor.dart';
import 'package:meiyou/core/utils/resources/modules/injecktor_module.dart';
import 'package:meiyou/domain/repositories/player_repository.dart';

class DomainModule extends InjecktorModule {
  @override
  void inject() {
    InjectKtor.addLazySingleton(() => PlayerRepository());
    
  }
}
