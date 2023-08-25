part of 'search_response_bloc.dart';

sealed class SearchResponseState extends Equatable {
  final SearchResponseEntity? selected;
  final List<SearchResponseEntity>? searchResponses;
  final MeiyouException? error;
  const SearchResponseState({this.searchResponses, this.selected, this.error});

  @override
  List<Object> get props => [selected!, searchResponses!];
}

final class SearchResponseSearching extends SearchResponseState {
  const SearchResponseSearching();
}

final class SearchResponseFailed extends SearchResponseState {
  const SearchResponseFailed([MeiyouException? error]) : super(error: error);
}

final class SearchResponseSuccess extends SearchResponseState {
  const SearchResponseSuccess(List<SearchResponseEntity> searchResponses)
      : super(searchResponses: searchResponses);
}

