import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou_extensions_lib/models.dart';

class ExpandHomePageParams {
  final HomePage homePage;
  final Media Function(IMedia) mapper;

  ExpandHomePageParams({required this.homePage, required this.mapper});
}
