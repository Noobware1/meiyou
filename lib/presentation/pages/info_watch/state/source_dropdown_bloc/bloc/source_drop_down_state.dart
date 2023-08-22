part of 'source_drop_down_bloc.dart';

sealed class SourceDropDownState extends Equatable {
  final BaseProvider provider;
  // final List<SearchResponseEntity>? searchResponses;
  final MeiyouException? error;
  const SourceDropDownState({
    required this.provider,
    this.error,
    // this.searchResponses
  });

  @override
  List<Object> get props => [
        provider,
        // searchResponses!
      ];
}

class SourceDropDownSearchLoading extends SourceDropDownState {
  const SourceDropDownSearchLoading({required super.provider});
}

class SourceDropDownSearchSuccess extends SourceDropDownState {
  const SourceDropDownSearchSuccess({
    required super.provider,
    // required List<SearchResponseEntity> searchResponses
  });
  // : super(searchResponses: searchResponses);
}

class SourceDropDownSearchError extends SourceDropDownState {
  const SourceDropDownSearchError(
      {required super.provider, required MeiyouException error})
      : super(error: error);
}
