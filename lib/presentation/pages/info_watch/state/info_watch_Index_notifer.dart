import 'package:flutter/material.dart';
import 'package:meiyou/presentation/pages/info_watch/state/info_and_watch_index_value.dart';

class InfoWatchIndexNotifer extends ValueNotifier<InfoWatchIndexValue> {
  InfoWatchIndexNotifer([super.value = const InfoWatchIndexValue(index: 1)]);

  void update(int index) => value = value.copyWith(index: index);
}
