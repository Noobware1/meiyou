import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/domain/entities/subtitle.dart';

class CurrentSubtitleCubit extends Cubit<SubtitleEntity?> {
  CurrentSubtitleCubit([SubtitleEntity? subtitle]) : super(subtitle);

  selectSubtitle(SubtitleEntity? subtitle) => emit(subtitle);
}
