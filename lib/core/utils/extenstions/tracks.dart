import 'package:media_kit/media_kit.dart';

extension FixTracks on Tracks {
  List<VideoTrack> get getFixedVideoTracks =>
      video.where((element) => element.id != 'no').toList();

  List<AudioTrack> get getFixedAudioTracks =>
      audio.where((element) => element.id != 'no').toList();

  List<SubtitleTrack> get getFixedSubtitleTracks =>
      subtitle.where((element) => element.id != 'auto').toList();
}
