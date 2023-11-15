
import 'package:meiyou/data/models/extractor_link.dart';
import 'package:meiyou/domain/entities/media.dart';

abstract class ExtractorApi {
  ExtractorApi(this.extractorLink);

  final ExtractorLink extractorLink;

  Future<MediaEntity> extract();
}