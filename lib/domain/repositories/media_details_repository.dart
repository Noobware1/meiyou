import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/meta_response.dart';

abstract interface class MediaDetailsRepository {
  Future<ResponseState<MediaDetailsEntity>> getMediaDetails(
      MetaResponseEntity response);
}
