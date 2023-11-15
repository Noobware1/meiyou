import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/data/models/plugin_list.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';

part 'plugins_page_event.dart';
part 'plugins_page_state.dart';

class PluginsPageBloc extends Bloc<PluginsPageEvent, PluginsPageState> {
  PluginsPageBloc() : super(PluginsPageInitial()) {
    on<PluginsPageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
