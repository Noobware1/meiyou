import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/stream_utils/state_stream.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:nice_dart/nice_dart.dart';

class BannerViewModel {
  BannerViewModel({
    required StateNotifier<List<Media>> stateListenable,
    required void Function(Media) onPressed,
    required void Function(Media) onLongPressed,
    required void Function() onScrollEnd,
  })  : _stateListenable = stateListenable,
        _onPressed = onPressed,
        _onLongPressed = onLongPressed,
        _pageNotifier = StateNotifier(0),
        _pageController = PageController(),
        _onScrollEnd = onScrollEnd {
    _pageController.addListener(() {
      _pageNotifier.setState(_pageController.page?.round() ?? 0);
      // onScrollEnd();
    });
  }

  final StateNotifier<List<Media>> _stateListenable;
  final void Function(Media) _onPressed;
  final void Function(Media) _onLongPressed;
  final PageController _pageController;
  final StateNotifier<int> _pageNotifier;
  final void Function() _onScrollEnd;

  StateNotifier<List<Media>> get listenable => _stateListenable;

  PageController get pageController => _pageController;

  StateNotifier<int> get pageNotifier => _pageNotifier;

  Media get _currentMedia => _stateListenable.state[_pageNotifier.state];

  void onPressed() {
    _onPressed(_currentMedia);
  }

  void onLongPressed() {
    _onLongPressed(_currentMedia);
  }

  bool onScroll(ScrollNotification notification) {
    if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
      _onScrollEnd();
    }
    return false;
  }

  Future<void> moveNext() {
    return _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> movePrevious() {
    return _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> onBannerTapDown(TapDownDetails details, double width) {
    if (details.globalPosition.dx < width / 2) {
      return movePrevious();
    } else {
      return moveNext();
    }
  }

  void dispose() {
    _pageController.dispose();
    _pageNotifier.dispose();
  }
}
