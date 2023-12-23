import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou_extensions_lib/meiyou_extensions_lib.dart';

class SubtitleState {
  final List<Subtitle> subtitles;
  final int selectedIndex;

  const SubtitleState({required this.subtitles, required this.selectedIndex});

  static const noSubtitle =
      SubtitleState(subtitles: [Subtitle.noSubtitle], selectedIndex: 0);

  SubtitleState copyWith({List<Subtitle>? subtitles, int? selectedIndex}) {
    return SubtitleState(
        subtitles: subtitles ?? this.subtitles,
        selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  Subtitle get current => subtitles[selectedIndex];
}

class SubtitleCubit extends Cubit<SubtitleState> {
  SubtitleCubit() : super(SubtitleState.noSubtitle);

  void addSubtitles(List<Subtitle>? subtitles) {
    emit(SubtitleState(
        subtitles: [Subtitle.noSubtitle, ...?subtitles], selectedIndex: 0));
  }

  void changeSubtitle(Subtitle subtitle) {
    if (subtitle == Subtitle.noSubtitle) {
      return emit(state.copyWith(selectedIndex: 0));
    }
    final index = state.subtitles.indexOf(subtitle);
    if (index != -1) {
      return emit(state.copyWith(selectedIndex: index));
    }
  }
}
