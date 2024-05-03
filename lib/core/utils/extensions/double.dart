import 'package:meiyou/core/utils/resources/screen_size.dart';

extension DoubleExtension on double {
  ScreenSize get screenSize =>
      this > 900 ? ScreenSize.Desktop : ScreenSize.Mobile;
}
