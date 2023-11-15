import 'package:equatable/equatable.dart';
import 'package:meiyou/domain/entities/meta_response.dart';

class MetaResultsEntity extends Equatable {
  final int totalPage;
  final List<MetaResponseEntity> metaResponses;

  const MetaResultsEntity(
      {required this.totalPage, required this.metaResponses});

  @override
  List<Object?> get props => [totalPage, metaResponses];
}
