import 'package:equatable/equatable.dart';
import 'package:meiyou/domain/entities/row.dart';

class MainPageEntity extends Equatable {
  final List<MetaRowEntity> rows;

  const MainPageEntity(this.rows);

  @override
  List<Object?> get props => [rows];
}
