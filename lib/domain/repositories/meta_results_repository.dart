import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/results.dart';

abstract interface class MetaResultsRepository {
  Future<ResponseState<MetaResultsEntity>> getSearch(String query,
      {int page = 1, bool isAdult = false});

// Future<ResponseState<MetaResultsEntity>> get
}
