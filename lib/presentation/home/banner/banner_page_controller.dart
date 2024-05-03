import 'package:flutter/material.dart';

class BannerPageController extends ChangeNotifier {
  final PageController pageController;

  BannerPageController(this.pageController);

  int _currentPage = 0;

  int get currentPage => _currentPage;

  void onPageChanged(int page) {
    _currentPage = page;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
