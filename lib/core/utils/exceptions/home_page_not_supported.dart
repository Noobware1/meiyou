import 'package:meiyou_extensions_lib/models.dart';

class HomePageNotSupported implements Exception {
  final Source source;

  HomePageNotSupported(this.source);

  @override
  String toString() {
    return 'HomePageNotSupported: HomePage is not supported for ${source.runtimeType}';
  }
}
