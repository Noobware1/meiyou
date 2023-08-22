part of 'search_response_bloc.dart';

sealed class SearchResponseState extends Equatable {
  final String title;
  final List<SearchResponseEntity>? searchResponses;
  final SearchResponseEntity? searchResponse;
  const SearchResponseState(
      {this.searchResponse, this.searchResponses, required this.title});

  @override
  List<Object> get props => [title];
}

final class SearchResponseStateWithData extends SearchResponseState {
  const SearchResponseStateWithData(
      {required SearchResponseEntity searchResponse,
      required String title,
      required List<SearchResponseEntity> searchResponses})
      : super(
            searchResponse: searchResponse,
            searchResponses: searchResponses,
            title: 'Found: $title');
}

final class SearchResponseStateWithNoData extends SearchResponseState {
  const SearchResponseStateWithNoData(String title)
      : super(title: 'Not Found $title');
}

final class SearchResponseStateLoading extends SearchResponseState {
  const SearchResponseStateLoading(String title)
      : super(title: 'Searching: $title');
}
