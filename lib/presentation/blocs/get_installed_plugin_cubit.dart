import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/domain/entities/plugin.dart';

class InstalledPluginCubit extends Cubit<List<PluginEntity>> {
  late final StreamSubscription _subtscription;

  InstalledPluginCubit(Stream<List<PluginEntity>> stream) : super([]) {
    _subtscription = stream.listen((plugins) {
      emit(plugins);
    });
  }

  @override
  Future<void> close() {
    _subtscription.cancel();
    return super.close();
  }
}
