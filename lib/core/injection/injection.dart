import 'package:get_it/get_it.dart';
import 'package:meiyou/core/injection/modules/app_module.dart';
import 'package:meiyou/core/injection/modules/domain_module.dart';
import 'package:meiyou/core/injection/modules/preference_module.dart';
import 'package:meiyou_extensions_lib/preference.dart';

final getIt = GetIt.instance;

Future<void> initInjectionModules() async {
  await PreferenceModule().call(getIt);
  await AppModule().call(getIt);
  await DomainModule().call(getIt);
}
