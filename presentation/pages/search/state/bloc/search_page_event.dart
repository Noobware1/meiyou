part of 'search_page_bloc.dart';

sealed class SearchPageEvent extends Equatable {
  final String query;
  const SearchPageEvent(this.query);

  @override
  List<Object> get props => [query];
}

class Search extends SearchPageEvent {
  const Search(super.query);
}
