import 'package:equatable/equatable.dart';

class GeneralSettingsEntity extends Equatable {
  final int selectedResponsesCache;

  final int responesCache;

  const GeneralSettingsEntity(
      {required this.selectedResponsesCache, required this.responesCache});

  @override
  List<Object?> get props => [selectedResponsesCache, responesCache];
}
