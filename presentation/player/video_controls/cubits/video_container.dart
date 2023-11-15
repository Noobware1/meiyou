import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/domain/entities/video_container.dart';

class VideoContainer extends Cubit<VideoContainerEntity> {
  VideoContainer(VideoContainerEntity current) : super(current);

  void addSubtitle(VideoContainerEntity videoContainer) => emit(videoContainer);
}
