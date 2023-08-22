import 'package:flutter/material.dart';

class BannerPageViewController extends ChangeNotifier {
 
  int get page => _page;

  int _page = 0;

  void onPageChanged(int page) {
    _page = page;

    notifyListeners();
  }
}
