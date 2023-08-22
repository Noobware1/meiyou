class InfoWatchIndexValue {
  final int index;

  const InfoWatchIndexValue({this.index = 1});

  InfoWatchIndexValue copyWith({int? index}) {
    return InfoWatchIndexValue(index: index ?? this.index);
  }
}
