// ignore_for_file: constant_identifier_names

enum ScreenSize {
  Mobile,
  Desktop;

  bool get isMobile => this == ScreenSize.Mobile;
  
  bool get isDesktop => this == ScreenSize.Desktop;
}
