part of 'search_response_bloc.dart';

sealed class SearchResponseEvent extends Equatable {
  final String title;
  final List<SearchResponseEntity>? searchResponses;
  // final SearchResponseEntity? searchResponse;
  const SearchResponseEvent({
    this.searchResponses,
    required this.title,

    //  this.searchResponse
  });

  @override
  List<Object> get props => [
        searchResponses!, title,
        // searchResponse!
      ];
}

class SearchResponseSearching extends SearchResponseEvent {
  const SearchResponseSearching(String title) : super(title: title);
}

class SearchResponseSearchSuccess extends SearchResponseEvent {
  const SearchResponseSearchSuccess(
      List<SearchResponseEntity> searchResponses,

      // SearchResponseEntity searchResponse,
      String title)
      : super(
            searchResponses: searchResponses,
            // searchResponse: searchResponse,
            title: title);
}

class SearchResponseFailed extends SearchResponseEvent {
  const SearchResponseFailed(String title) : super(title: title);
}
