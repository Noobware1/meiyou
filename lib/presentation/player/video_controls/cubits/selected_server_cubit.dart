import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/domain/entities/video.dart';
import 'package:meiyou/domain/entities/video_container.dart';
import 'package:meiyou/domain/entities/video_server.dart';
import 'package:meiyou/presentation/widgets/video_server_view.dart';

class SelectedServerCubit extends Cubit<SelectedServer> {
  SelectedServerCubit(SelectedServer current) : super(current);

  void changeServer(SelectedServer server) => emit(server);

  VideoEntity get video =>
      state.videoContainerEntity.videos[state.selectedVideoIndex];

Map<String , String>? get headers => state.videoContainerEntity.headers;

}
