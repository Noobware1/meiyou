// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meiyou/domain/repositories/plugin_repository.dart';
// import 'package:meiyou/domain/usecases/plugin_repository/get_installed_plugins_usecase.dart';
// import 'package:meiyou/domain/usecases/plugin_repository/load_plugin_usecase.dart';

// class PluginRepositoryUseCaseProvider {
//   late final GetInstalledPluginsUseCase getInstalledPluginsUseCase;
//   late final LoadPluginUseCase loadPluginUseCase;

//   PluginRepositoryUseCaseProvider(PluginRepository repository)
//       : getInstalledPluginsUseCase = GetInstalledPluginsUseCase(repository),
//         loadPluginUseCase = LoadPluginUseCase(repository);

//   Widget createProvider({required Widget child}) {
//     return RepositoryProvider.value(
//       value: this,
//       child: child,
//     );
//   }
// }
