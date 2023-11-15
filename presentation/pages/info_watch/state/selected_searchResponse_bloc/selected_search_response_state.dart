part of 'selected_search_response_bloc.dart';

sealed class SelectedSearchResponseState extends Equatable {
  // final BaseProvider provider;
  final String title;
  final SearchResponseEntity searchResponse;

  const SelectedSearchResponseState(
      {required this.title,
      this.searchResponse = SearchResponseEntity.empty,
      //required this.provider
      });

  @override
  List<Object> get props => [title, searchResponse];
}

final class SelectedSearchResponseFinding extends SelectedSearchResponseState {
  const SelectedSearchResponseFinding(String title, 
  // BaseProvider provider
  )
      : super(title: 'Finding: $title',
       //provider: provider
       );
}

final class SelectedSearchResponseFound extends SelectedSearchResponseState {
  const SelectedSearchResponseFound(
      String title, SearchResponseEntity searchResponse, 
      //BaseProvider provider
      )
      : super(
            title: 'Found: $title',
            searchResponse: searchResponse,
            // provider: provider
            );
}


final class SelectedSearchResponseSelected extends SelectedSearchResponseState {
  const SelectedSearchResponseSelected(
      String title, SearchResponseEntity searchResponse, 
      //BaseProvider provider
      )
      : super(
            title: 'Selected: $title',
            searchResponse: searchResponse,
            // provider: provider
            );
}

final class SelectedSearchResponseNotFound extends SelectedSearchResponseState {
  final MeiyouException error;
  const SelectedSearchResponseNotFound(
      String title, this.error,
      //  BaseProvider provider
       )
      : super(title: 'Not Found: $title',
      //  provider: provider
      )
      ;
}
