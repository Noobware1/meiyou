import 'package:flutter/material.dart';
import 'package:meiyou/features/home/domain/models/expanded_home_page_list.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/src/result.dart';

class HomeRowViewModel {
  final StateNotifier<ExpandedHomePageList> listenable;
  final ScrollController _scrollController;
  final void Function(Media) _onPressed;
  final void Function(Media) _onLongPressed;

  HomeRowViewModel({
    required this.listenable,
    required void Function(Media) onPressed,
    required void Function(Media) onLongPressed,
    required void Function(String) onScrollEnd,
  })  : _scrollController = ScrollController(),
        _onPressed = onPressed,
        _onLongPressed = onLongPressed {
    _scrollController.addListener(() {
      _onScrollEnd(onScrollEnd);
    });
  }

  ScrollController get scrollController => _scrollController;

  void onPressed(Media preview) {
    return _onPressed(preview);
  }

  void onLongPressed(Media preview) {
    return _onLongPressed(preview);
  }

  void _onScrollEnd(void Function(String) callback) {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (listenable.state.hasNext) {
        callback(listenable.state.title);
      }
    }
  }

  void dispose() {
    _scrollController.dispose();
  }
}
