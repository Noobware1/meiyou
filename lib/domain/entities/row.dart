import 'package:equatable/equatable.dart';
import 'package:meiyou/domain/entities/results.dart';

class MetaRowEntity extends Equatable {
  final String rowTitle;
  final MetaResultsEntity resultsEntity;
  final Future<MetaResultsEntity> Function([int page])? loadMoreData;

  const MetaRowEntity(
      {required this.rowTitle, required this.resultsEntity, this.loadMoreData});

  @override
  List<Object?> get props => [rowTitle, resultsEntity, loadMoreData];
}
